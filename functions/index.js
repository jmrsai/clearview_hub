const {onCall} = require("firebase-functions/v2/https");
const {VertexAI} = require("@google-cloud/vertexai");
const admin = require("firebase-admin");
const functions = require("firebase-functions");
admin.initializeApp();

exports.analyzeMedicalReport = onCall(async (request) => {
  if (!request.auth) throw new Error("Unauthorized");
  const vertexAI = new VertexAI({project: 'clear-view-hub', location: 'us-central1'});
  const model = vertexAI.getGenerativeModel({model: 'gemini-2.5-flash'});
  const prompt = `WHO PECI 2022. Analyze: ${JSON.stringify(request.data)}. Flag emergencies.`;
  const result = await model.generateContent(prompt);
  return {analysis: result.response.text(), disclaimer: "Screening aid only"};
});

exports.findNearbyEyeCare = onCall(async (request) => {
  if (!request.auth) throw new Error("Unauthorized");
  const {lat, lng} = request.data;
  const apiKey = process.env.GOOGLE_MAPS_KEY;
  const url = `https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${lat},${lng}&radius=5000&type=hospital&keyword=eye|ophthalmology&key=${apiKey}`;
  const response = await fetch(url);
  const data = await response.json();
  return data.results.slice(0,20).map(p => ({
    place_id: p.place_id, name: p.name, lat: p.geometry.location.lat,
    lng: p.geometry.location.lng, rating: p.rating || 0, open_now: p.opening_hours?.open_now || false
  }));
});

exports.deleteOldPhotos = functions.pubsub.schedule('every 24 hours').onRun(async () => {
  const bucket = admin.storage().bucket();
  const [files] = await bucket.getFiles({prefix: 'temp_scans/'});
  const now = Date.now();
  await Promise.all(files.map(f => now - new Date(f.metadata.timeCreated).getTime() > 86400000 ? f.delete() : null));
});