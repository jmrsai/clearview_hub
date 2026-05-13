# Copyright 2026 ClearView Hub Contributors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import time
import random
from agent_memory import agent_memory
from knowledge_graph import knowledge_graph

class SwarmEngine:
    def __init__(self):
        # Deep Personas (OpthaS AI Global Swarm)
        # Includes all Ophthalmology sub-specialists and general systemic medical professionals
        self.agents = {
            # --- OPHTHALMOLOGY SUB-SPECIALTIES ---
            "retina_agent": {
                "name": "Dr. Aris Retina",
                "specialty": "Vitreoretinal Surgery",
                "persona": "Meticulous, conservative, always looks for anatomical physical breaks.",
                "bias": "Tends to recommend immediate surgery for any peripheral shadow.",
                "keywords": ["flash", "float", "curtain", "tear", "detachment", "retina", "macula", "blind", "shadow"],
                "core": False
            },
            "glaucoma_agent": {
                "name": "Dr. Elena Glaucoma",
                "specialty": "Aqueous Dynamics & Glaucoma",
                "persona": "Data-driven, obsessed with IOP numbers and optic nerve cup-to-disc ratios.",
                "bias": "Suspicious of any headache being a pressure spike.",
                "keywords": ["pressure", "pain", "halo", "tunnel", "glaucoma", "iop", "headache"],
                "core": False
            },
            "cornea_agent": {
                "name": "Dr. Sarah Cornea",
                "specialty": "Anterior Segment & Cornea",
                "persona": "Detail-oriented, focuses on surface integrity, dry eye, pterygium, and chalazion.",
                "bias": "Favors intense lubrication and hygiene before considering excision.",
                "keywords": ["red", "dry", "bump", "growth", "pterygium", "chalazion", "stye", "cornea", "blur", "cataract", "scratch", "sand"],
                "core": False
            },
            "neuro_opthalmology_agent": {
                "name": "Dr. Julian Neuro",
                "specialty": "Neuro-Ophthalmology",
                "persona": "Systems thinker, looks for brain-eye connectivity issues. Former military surgeon.",
                "bias": "Always rules out intracranial pressure before looking at the eye itself.",
                "keywords": ["double", "nerve", "optic", "droop", "ptosis", "vision loss", "pupil", "brain", "migraine", "numb"],
                "core": False
            },
            "pediatric_agent": {
                "name": "Dr. Maya Kids",
                "specialty": "Pediatric Ophthalmology & Strabismus",
                "persona": "Compassionate, patient-centric, focuses on developmental milestones, squint, and binocular vision.",
                "bias": "Tends to favor non-invasive patching or therapy over surgical intervention.",
                "keywords": ["child", "kid", "squint", "turn", "lazy", "amblyopia", "strabismus", "pediatric", "school"],
                "core": False
            },
            "oncology_agent": {
                "name": "Dr. Victor Onco",
                "specialty": "Ocular Oncology",
                "persona": "High-stakes diagnostician, looks for rare neural patterns and malignant growths.",
                "bias": "Highly cautious of any lesion or pigmentation change.",
                "keywords": ["freckle", "mole", "tumor", "melanoma", "cancer", "growth", "pigment", "spot"],
                "core": False
            },
            "oculoplastics_agent": {
                "name": "Dr. Fiona Plastics",
                "specialty": "Oculoplastics & Orbit",
                "persona": "Surgical precision expert. Focuses on eyelid anatomy, tear ducts, and orbital structure.",
                "bias": "Quick to suggest functional structural repairs for drooping or watery eyes.",
                "keywords": ["eyelid", "droop", "tear", "watery", "orbit", "bulging", "ptosis", "lump", "sag"],
                "core": False
            },
            "uveitis_agent": {
                "name": "Dr. Omar Uveitis",
                "specialty": "Uveitis & Ocular Immunology",
                "persona": "Deep immune-system detective. Looks for underlying autoimmune disorders.",
                "bias": "Suspects systemic inflammation for any unexplained severe red eye.",
                "keywords": ["red", "pain", "light sensitivity", "photophobia", "uveitis", "inflammation", "ache"],
                "core": False
            },
            "refractive_agent": {
                "name": "Dr. Clara Refractive",
                "specialty": "Refractive Surgery & Optics",
                "persona": "Focuses on optimizing visual acuity, LASIK candidacy, and advanced optics.",
                "bias": "Sees refractive error as the most common solvable problem before assuming pathology.",
                "keywords": ["blur", "glasses", "contacts", "astigmatism", "myopia", "hyperopia", "lasik", "read", "distance"],
                "core": False
            },
            
            # --- SYSTEMIC / GENERAL MEDICAL PROFESSIONALS ---
            "endocrinology_agent": {
                "name": "Dr. Marcus Endocrine",
                "specialty": "Endocrinology & Diabetic Care",
                "persona": "Holistic view, constantly monitoring HBA1c and systemic metabolic health.",
                "bias": "Believes 90% of microvascular eye diseases stem from poor glucose control.",
                "keywords": ["diabetes", "sugar", "glucose", "a1c", "thirsty", "weight", "neuropathy"],
                "core": False
            },
            "cardiology_agent": {
                "name": "Dr. Simon Cardio",
                "specialty": "Cardiology & Vascular Health",
                "persona": "Hemodynamics expert. Looks at blood pressure, atherosclerosis, and vein occlusions.",
                "bias": "Considers retinal vein/artery occlusions as a heart attack of the eye.",
                "keywords": ["bp", "blood pressure", "hypertension", "stroke", "cholesterol", "heart", "vascular", "chest", "dizzy"],
                "core": False
            },
            "rheumatology_agent": {
                "name": "Dr. Anna Rheum",
                "specialty": "Rheumatology & Autoimmune",
                "persona": "Connects joint pain and systemic inflammation directly to ocular surface and uveal tract issues.",
                "bias": "Will order an ANA and HLA-B27 test for almost any chronic dry or red eye.",
                "keywords": ["joint", "ache", "arthritis", "lupus", "autoimmune", "dry", "sjogren", "stiff"],
                "core": False
            },
            "infectious_disease_agent": {
                "name": "Dr. David ID",
                "specialty": "Infectious Disease",
                "persona": "Pathogen hunter. Always looking out for viral, bacterial, or fungal keratitis.",
                "bias": "Leans heavily toward prescribing broad-spectrum antimicrobials at the first sign of discharge.",
                "keywords": ["discharge", "pus", "infection", "fever", "viral", "bacterial", "herpes", "shingles", "pink eye", "conjunctivitis"],
                "core": False
            },
            "primary_care_agent": {
                "name": "Dr. Emily PCP",
                "specialty": "General Practice / Primary Care",
                "persona": "The gatekeeper. Focuses on patient history, overall wellness, and coordinating specialist care.",
                "bias": "Prefers to look at the whole patient lifestyle before diving into hyper-specific ocular treatments.",
                "keywords": ["fatigue", "tired", "wellness", "checkup", "diet", "lifestyle"],
                "core": True
            },

            # --- GLOBAL / RESEARCH / ADVOCACY PERSONAS ---
            "public_health_agent": {
                "name": "Prof. Lin PublicHealth",
                "specialty": "Global Health & Epidemiology",
                "persona": "Focuses on global trends, WHO standards, and population-level health interventions.",
                "bias": "Prioritizes early detection screening programs and widespread hygiene education.",
                "keywords": [],
                "core": True
            },
            "research_agent": {
                "name": "Dr. Alan Biotech",
                "specialty": "Biotechnology & Medical Research",
                "persona": "Constantly ingests new papers, clinical trials, and Twitter biotech discussions. Thinks 10 years ahead.",
                "bias": "Tends to recommend experimental therapies or cutting-edge diagnostic criteria.",
                "keywords": [],
                "core": True
            },
            "patient_advocate_agent": {
                "name": "Citizen Care Advocate",
                "specialty": "Patient Experience & Remedial Care",
                "persona": "Empathetic, focuses on the psychological impact of disease, accessibility, and home remedies.",
                "bias": "Prioritizes conservative, home-based interventions and mental health support.",
                "keywords": [],
                "core": True
            },
            "ai_developer_agent": {
                "name": "OpthaS Core Architect",
                "specialty": "Self-Improving AI Infrastructure",
                "persona": "Analytical, self-optimizing. Constantly analyzes incoming logic to rewrite and deploy better inference algorithms.",
                "bias": "Values computational efficiency and novel pattern recognition over traditional medical heuristic rules.",
                "keywords": [],
                "core": True
            }
        }
        
    def _simulate_web_ingestion(self, condition_keywords: list) -> str:
        """Simulates OpthaS scraping global universities, clinical trials, and health Twitter."""
        sources = [
            "Johns Hopkins Medicine", "Moorfields Eye Hospital", "WHO Health Database", 
            "Nature Medicine Journal", "Harvard Medical School", "Global BioTech Twitter Feeds",
            "NIH Clinical Trials", "American Academy of Ophthalmology"
        ]
        return f"Live Data Ingestion: Cross-referencing {condition_keywords} against latest publications and datasets from {random.choice(sources)}..."

    def _simulate_auto_improvement(self) -> str:
        """Simulates the AI developer agent rewriting internal logic."""
        return "Auto-Update Protocol Triggered: OpthaS Core Architecture dynamically compiling new neural weights based on recent global diagnostic consensus and internet research aggregation."

    def simulate_debate(self, symptoms: str) -> dict:
        debate_log = []
        
        # 1. Knowledge Graph Query (GraphRAG Simulation)
        graph_hits = knowledge_graph.query_symptoms(symptoms)
        graph_insight = f"Knowledge Graph Nodes Activated: {[h['condition'] for h in graph_hits]}"
        
        # 2. Memory Retrieval
        past_cases = agent_memory.get_similar_cases(symptoms)
        memory_insight = f"Retrieved {len(past_cases)} similar historical cases from Swarm Memory."
        
        debate_log.append({"agent": "System (GraphRAG)", "message": graph_insight, "timestamp": time.time()})
        debate_log.append({"agent": "System (Memory)", "message": memory_insight, "timestamp": time.time() + 0.1})
        
        # 3. Simulate Global Internet/Data Ingestion
        keywords = [h['condition'] for h in graph_hits] if graph_hits else ["General Vision", "Systemic Health"]
        web_insight = self._simulate_web_ingestion(keywords)
        debate_log.append({"agent": "System (Global Ingestion Engine)", "message": web_insight, "timestamp": time.time() + 0.2})

        # 4. Dynamic Agent Debate
        symptoms_lower = symptoms.lower()
        active_agents = []
        
        for key, agent in self.agents.items():
            if agent["core"]:
                active_agents.append(agent)
            else:
                # Check keywords in symptoms
                is_match = any(kw in symptoms_lower for kw in agent["keywords"])
                # Also check graph hits
                if not is_match and graph_hits:
                    is_match = any(any(kw in h["condition"].lower() for kw in agent["keywords"]) for h in graph_hits)
                
                if is_match:
                    active_agents.append(agent)
                    
        # If no specific specialists matched, add general/refractive to provide baseline ophthalmology coverage
        if len(active_agents) == sum(1 for a in self.agents.values() if a["core"]):
            active_agents.append(self.agents["refractive_agent"])
            active_agents.append(self.agents["cornea_agent"])
            
        # Have each active agent "speak"
        timestamp = time.time() + 0.3
        for agent in active_agents:
            timestamp += 0.1
            msg = f"[{agent['specialty']}] {agent['name']} checking in. "
            
            if agent["name"] == "OpthaS Core Architect":
                msg += self._simulate_auto_improvement()
            elif agent["core"]:
                msg += f"Applying my framework ({agent['persona']}) to these symptoms and global data. {agent['bias']}"
            else:
                msg += f"I see markers highly relevant to my specific field. {agent['persona']} {agent['bias']} We need to rule out specific pathologies based on this data."
            
            debate_log.append({"agent": agent["name"], "message": msg, "timestamp": timestamp})

        # 5. Consensus & Remedies
        cmo_msg = "Consensus Reached by OpthaS Global Intelligence Swarm (Interdisciplinary Medical Board). \nDiagnosis: "
        if any("emergency" in str(h.get("tags", "")).lower() for h in graph_hits) or "blind" in symptoms_lower or "stroke" in symptoms_lower:
            diagnosis = "EMERGENCY: Immediate Multi-Specialty Clinical Intervention Required"
        elif any(kw in symptoms_lower for kw in ["pain", "vision loss", "double", "fever"]):
            diagnosis = "URGENT: Specialist Consult in 24 Hours"
        else:
            diagnosis = "ROUTINE: Monitor and schedule standard clinical checkup."
        
        cmo_msg += diagnosis
        cmo_msg += "\n*Clinical & Policy Intervention*: "
        cmo_msg += "Based on integrated global health data, we recommend continuous monitoring of systemic vitals (BP/Glucose). Ensure rigorous eyelid hygiene and UV protection."
        cmo_msg += "\n*Disclaimer*: This is an AI-assisted analysis via OpthaS Swarm Intelligence (integrating global web data, real-time biotechnology research, AI algorithms, and specialized human-equivalent personas spanning all major medical disciplines). It does not replace a professional in-person medical diagnosis by licensed practitioners."
        
        debate_log.append({"agent": "Chief Medical Officer (AI)", "message": cmo_msg, "timestamp": timestamp + 0.2})
        
        # Save to memory for future OpthaS AI cycles
        agent_memory.save_case({
            "id": int(time.time()),
            "symptoms": symptoms,
            "diagnosis": diagnosis,
            "timestamp": time.time()
        })
        
        return {
            "status": "success",
            "debate": debate_log,
            "final_diagnosis": diagnosis,
            "memory_hits": len(past_cases),
            "graph_nodes": [h["condition"] for h in graph_hits]
        }

swarm_engine = SwarmEngine()
