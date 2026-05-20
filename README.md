# Clear View Hub

An AI-driven eye health platform for diagnosis, therapy, and prevention based on WHO PECI 2022 guidelines.

## 🚀 Step 1: Environment Variables Setup

Create a `.env` file in the root directory (you can copy `.env.example`) and fill in your keys:
```env
GEMINI_API_KEY=your_gemini_api_key
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_supabase_anon_key
```

## 🔥 Step 2: Firebase Console Setup

1. **Create Project**: Go to [Firebase Console](https://console.firebase.google.com/) and create `clear-view-hub`.
2. **Add Android App**: Register `com.clearviewhub.app`.
   - Run `cd android && ./gradlew signingReport` to get your SHA-1.
   - Download `google-services.json` and place it in `android/app/`.
3. **Deploy Rules & Functions**:
   ```bash
   firebase login
   firebase deploy --only firestore:rules,storage:rules
   cd functions && npm install && cd ..
   firebase deploy --only functions
   ```
4. **Remote Config**: Add these parameters in the Firebase Console (Remote Config tab):
   - `clinical_mode_enabled` (Boolean) = `false`
   - `dr_model_version` (String) = `aidrss_v3_2025`
   - `who_guidelines_version` (String) = `peci_2022`
   - `emergency_mode_enabled` (Boolean) = `true`
5. **Run FlutterFire**:
   ```bash
   flutterfire configure --project=clear-view-hub
   ```

## ⚡ Step 3: Supabase Console Setup

1. **Create Project**: Go to [Supabase](https://supabase.com/) and create `clearviewhub-community`.
2. **SQL Editor**: Run the following SQL to set up the community tables:
   ```sql
   alter table auth.users enable row level security;

   create table community_posts (
     id uuid default gen_random_uuid() primary key,
     user_id uuid references auth.users not null,
     user_age int not null,
     topic text not null,
     content text not null,
     likes int default 0,
     approved boolean default false,
     created_at timestamp with time zone default now()
   );

   create policy "Users can read approved posts" on community_posts for select using (approved = true);
   create policy "Users 13+ can create posts" on community_posts for insert with check (auth.uid() = user_id AND user_age >= 13);
   create policy "Users update own posts" on community_posts for update using (auth.uid() = user_id);

   alter publication supabase_realtime add table community_posts;
   ```

## 🤖 Step 4: ML Models

Place your `.tflite` models in the `assets/models/` folder:
- `external_eye_disease.tflite`
- `retfound.tflite` (for Body View AI)
- `glaucoma_cdr.tflite`
- `dr_model.tflite`

## 📦 Step 5: Android Keystore & Build

1. **Generate Keystore**:
   ```bash
   keytool -genkey -v -keystore android/app/clearviewhub-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias clearviewhub
   ```
2. **Configure `key.properties`**: Create `android/key.properties`:
   ```properties
   storePassword=YOUR_STRONG_PASS
   keyPassword=YOUR_STRONG_PASS
   keyAlias=clearviewhub
   storeFile=clearviewhub-key.jks
   ```
3. **Build Release AAB**:
   ```bash
   flutter clean
   flutter pub get
   flutter build appbundle --release
   ```

## ⚠️ Legal Disclaimer
Keep `clinical_mode_enabled=false` in Remote Config until FDA 510(k) clearance is obtained. App must remain in "Wellness & Education" mode to avoid regulatory issues.
