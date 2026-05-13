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

import json
import os

class AgentMemory:
    def __init__(self, storage_path="agent_memory.json"):
        self.storage_path = storage_path
        self.memory = self._load()

    def _load(self):
        if os.path.exists(self.storage_path):
            with open(self.storage_path, 'r') as f:
                return json.load(f)
        return {"cases": [], "agent_consensus_history": []}

    def save_case(self, case_data):
        self.memory["cases"].append(case_data)
        with open(self.storage_path, 'w') as f:
            json.dump(self.memory, f, indent=4)

    def get_similar_cases(self, symptoms, limit=2):
        # In a real MiroFish system, this would use Vector Embeddings (Chroma/Pinecone)
        # Here we simulate with a simple keyword match
        similar = []
        for case in self.memory["cases"]:
            if any(word in case["symptoms"].lower() for word in symptoms.lower().split()):
                similar.append(case)
        return similar[:limit]

agent_memory = AgentMemory()
