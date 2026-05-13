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

class MedicalKnowledgeGraph:
    def __init__(self):
        # A simulated GraphRAG structure
        self.nodes = {
            "retinal_detachment": ["floaters", "flashes", "peripheral_shadow", "EMERGENCY"],
            "diabetic_retinopathy": ["blurry_vision", "diabetes_history", "leaking_vessels", "URGENT"],
            "angle_closure_glaucoma": ["eye_pain", "halos", "nausea", "red_eye", "CRITICAL"],
            "optic_neuritis": ["vision_loss", "pain_with_movement", "color_vision_change", "URGENT"],
            "dry_eye_syndrome": ["itchy_eyes", "burning", "foreign_body_sensation", "ROUTINE"],
        }

    def query_symptoms(self, symptoms_str):
        matches = []
        symptoms_str = symptoms_str.lower()
        for node, keywords in self.nodes.items():
            # Check if any keyword or the node name itself appears in the symptoms
            if any(key.replace("_", " ") in symptoms_str for key in keywords) or node.replace("_", " ") in symptoms_str:
                matches.append({"condition": node.replace("_", " ").title(), "tags": keywords})
        return matches

knowledge_graph = MedicalKnowledgeGraph()
