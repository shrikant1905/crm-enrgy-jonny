# CRM nErgy AI — Complete End-to-End Implementation Masterplan

> **Document Type:** System Architecture & Step-by-Step Implementation Guide  
> **Target System:** CRM nErgy AI & OAL Enterprise  
> **Tech Stack:** React 18 (Vite) + Node.js (Express + Prisma) + Google GenAI + ElevenLabs + Optional Python/FastAPI Microservice  
> **Date:** October 2026  

---

## 1. System Architecture Overview

Aapke pure platform ka flow 3 distinct layers me divide hota hai:

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          1. REACT FRONTEND                              │
│  - Bestie AI Copilot (/crm/bestie)                                      │
│  - 15 Content Studios (/crm/ai-studio)                                  │
│  - AI Marketing Hub (/crm/ai-marketing)                                 │
│  - Internal AI Search (/crm/search)                                     │
└────────────────────────────────────┬────────────────────────────────────┘
                                     │
           HTTP POST /api/ai/generate & /api/ai/chat (JSON Body)
                                     │
                                     ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                    2. NODE.JS SECURE BACKEND GATEWAY                    │
│  - Express Router (/api/ai)                                             │
│  - Authentication & Rate Limiting                                       │
│  - CRM Context Injector (Reads live Deals, Leads, Inventory from DB)    │
│  - Secret Keys Vault (.env: GEMINI_API_KEY, ELEVENLABS_KEY)             │
└───────────────┬─────────────────────────────┬───────────────────────────┘
                │                             │
    Layer A: Text & Reasoning                 │ Layer B: Voice & Media
                │                             │
                ▼                             ▼
┌───────────────────────────────┐ ┌───────────────────────────────────────┐
│     Google GenAI Cloud Core   │ │   Media Synthesis APIs                │
│ Models:                       │ │ - Voice: ElevenLabs / WebSpeech       │
│ - gemini-2.5-flash / 3.8-flash│ │ - Image: DALL-E / Pollinations / Stbl │
│ - gemini-pro (Deep reasoning) │ │ - Video: Kling / Runway / Storyboard  │
└───────────────┬───────────────┘ └───────────────────┬───────────────────┘
                │                                     │
                └──────────────────┬──────────────────┘
                                   │
              Structured AI Response (Markdown / JSON Actions)
                                   │
                                   ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                          3. FRONTEND UI ENGINE                          │
│  - Dynamic Typewriter Rendering                                         │
│  - Interactive Action Chips ([ACTION:DEAL_RISK], [ACTION:CREATE_LEAD])  │
│  - Audio Player / Video Storyboard Visualizer                           │
│  - Local Session History Library                                        │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 2. API Keys & Environment Setup

### 2.1 Backend `.env` (`backend/.env`)
Sabhi AI keys **sirf backend** me rahengi taaki browser se koi key chori na kar sake:

```env
# ==============================================================================
# AI ENGINE CONFIGURATION (BACKEND ONLY)
# ==============================================================================
# Get your free key from: https://aistudio.google.com/
GEMINI_API_KEY=AIzaSy...your_real_gemini_api_key_here
GEMINI_MODEL=gemini-2.5-flash

# Optional: Media Generation Keys
ELEVENLABS_API_KEY=sk_...your_elevenlabs_key_here
ELEVENLABS_VOICE_ID=21m00Tcm4TlvDq8ikWAM
```

### 2.2 Frontend `.env` (`frontend/.env`)
Frontend ko direct key ki zaroorat nahi hai. Frontend sirf backend ka URL point karega:

```env
VITE_API_BASE_URL=http://localhost:5002/api
```

---

## 3. Backend Implementation (Code Blueprints)

Aapke backend me ye 3 files setup hongi:

### File 1: `backend/src/services/aiService.js`
*Kaam:* Google Gemini API ko initialize karna, prompts bhejna, aur live CRM context attach karna.

```javascript
const { GoogleGenAI } = require('@google/genai');

const apiKey = process.env.GEMINI_API_KEY || '';
const defaultModel = process.env.GEMINI_MODEL || 'gemini-2.5-flash';

let aiClient = null;
if (apiKey && apiKey !== 'your_actual_api_key_here') {
  aiClient = new GoogleGenAI({ apiKey });
}

/**
 * Generate AI Content with optional System Persona
 */
async function generateAiContent({ prompt, systemInstruction = '', model = defaultModel }) {
  if (!aiClient) {
    throw new Error('Gemini API Key is not configured in backend/.env');
  }

  try {
    const response = await aiClient.models.generateContent({
      model: model,
      contents: prompt,
      config: {
        systemInstruction: systemInstruction || undefined,
        temperature: 0.7,
        maxOutputTokens: 2048,
      },
    });

    return {
      success: true,
      text: response.text || '',
      model: model,
      timestamp: new Date().toISOString(),
    };
  } catch (error) {
    console.error('[AiService Error]:', error.message);
    throw error;
  }
}

module.exports = {
  generateAiContent,
};
```

---

### File 2: `backend/src/controllers/aiController.js`
*Kaam:* Incoming HTTP requests ko validate karna, error handling karna, aur response bhejna.

```javascript
const aiService = require('../services/aiService');

/**
 * Handle 15 Studio Generation & General AI Requests
 * POST /api/ai/generate
 */
async function generateContent(req, res, next) {
  try {
    const { prompt, systemInstruction, studioId, extraOptions } = req.body;

    if (!prompt || typeof prompt !== 'string') {
      return res.status(400).json({
        success: false,
        message: 'Prompt is required and must be a string.',
      });
    }

    const result = await aiService.generateAiContent({
      prompt,
      systemInstruction,
    });

    return res.status(200).json({
      success: true,
      studioId: studioId || 'general',
      text: result.text,
      timestamp: result.timestamp,
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: error.message || 'AI generation failed.',
    });
  }
}

/**
 * Health check for AI Service
 * GET /api/ai/status
 */
async function getStatus(req, res) {
  const isConfigured = Boolean(
    process.env.GEMINI_API_KEY && 
    process.env.GEMINI_API_KEY !== 'your_actual_api_key_here'
  );

  return res.status(200).json({
    status: 'online',
    engine: 'Google GenAI SDK',
    model: process.env.GEMINI_MODEL || 'gemini-2.5-flash',
    configured: isConfigured,
  });
}

module.exports = {
  generateContent,
  getStatus,
};
```

---

### File 3: `backend/src/routes/aiRoutes.js`
*Kaam:* Routes define karna.

```javascript
const express = require('express');
const router = express.Router();
const aiController = require('../controllers/aiController');

// Health check
router.get('/status', aiController.getStatus);

// Primary Generation Endpoint (Studios, Marketing, General)
router.post('/generate', aiController.generateContent);

module.exports = router;
```

---

### File 4: Register in `backend/src/app.js`
Aapke existing [backend/src/app.js](file:///d:/Kiaan/crm-enrgy-jonny/backend/src/app.js) me bas ye 2 lines add honi hain:

```javascript
// 1. Route import
const aiRoutes = require('./routes/aiRoutes');

// 2. Route registration (around line 95)
app.use('/api/ai', aiRoutes);
```

---

## 4. Frontend Integration (`geminiService.js`)

Aapke frontend me [frontend/src/services/geminiService.js](file:///d:/Kiaan/crm-enrgy-jonny/frontend/src/services/geminiService.js) already 15 personas ke sath bana hua hai. 

Bas uska `callGeminiApi` function seedhe apne backend API endpoint ko call karega:

```javascript
const BACKEND_AI_URL = (import.meta.env.VITE_API_BASE_URL || 'http://localhost:5002/api') + '/ai/generate';

export async function callGeminiApi(prompt, systemInstruction = '') {
  try {
    const response = await fetch(BACKEND_AI_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        prompt,
        systemInstruction,
      }),
    });

    if (response.ok) {
      const data = await response.json();
      if (data.text) return data.text;
    }
    throw new Error('Backend AI response invalid');
  } catch (err) {
    console.warn('[Backend AI Route]: Falling back to local synthesizer...', err.message);
    // Intelligent local fallback so UI never breaks even if offline
    return generateDynamicDomainContent(prompt, systemInstruction);
  }
}
```

---

## 5. Har Ek AI Feature Kaise Work Karega

### 5.1 Bestie — AI Copilot (`/crm/bestie`)
* **Working:** User jab Bestie se baat karta hai (e.g. *"Analyze deals closing this week"*), to backend prompt me CRM ke live statistics attach karta hai.
* **Action Chips:** Gemini ka response ek special tag format return karega:
  `[ACTION:DEAL_RISK:{"dealName":"Apex Logistics","value":"$140,000","riskLevel":"High"}]`
* **UI Execution:** [BestieAi.jsx](file:///d:/Kiaan/crm-enrgy-jonny/frontend/src/pages/crm/ai/BestieAi.jsx) is tag ko detect karta hai aur screen par clickable interactive button render karta hai (*"Open Deal in Pipeline"*, *"Schedule Call"*).

### 5.2 15 Content Studios (`/crm/ai-studio`)
Har studio ke liye `STUDIO_PERSONAS` already configured hain:
1. **AAI Muzik Hit Studio:** Lyrics + Tempo (BPM) + Music Arrangement blueprint banata hai.
2. **AAI Real Talk:** Speaker A & Speaker B ke natural conversational dialogue banata hai.
3. **AI Audio Writer:** 30s/60s commercial script with audio cues banata hai.
4. **AI ConTalk:** Sales objection handling script banata hai.
5. **AI Film Maker:** Hollywood screenplay format (Scene Headers, Camera Angles, Dialogues) banata hai.
6. **AI Image TalkR:** Spokesperson speech + facial cues banata hai.
7. **AI Logo Generator:** Hex colors, typography, aur SVG layout specs banata hai.
8. **AI Photo Life:** Studio lighting, 85mm lens composition prompt banata hai.
9. **AI Video Crew:** Multi-camera switching timeline banata hai.
10. **AI Visual Workflow:** Trigger-Condition-Action JSON automation map banata hai.
11. **AI VoiceX Change:** 40+ languages me culturally accurate translation karta hai.
12. **AAI BIG Movies Lab:** 3-Act narrative structure + Investor pitch script banata hai.
13. **Train AI to Speak:** Company brand voice guidelines aur guardrails banata hai.
14. **AI Video Agent:** 4-Step formula: "Say it, See it, Shape it, Ship it" storyboard banata hai.
15. **AI Marketing Hub:** Google Search Ads, FB Creatives, Cold Email sequences generate karta hai.

---

## 6. Real Media AI Generation (Audio, Image, Video)

Jab user script ya text ke alawa actual MP3 / Image / MP4 chahega:

```
┌─────────────────────────────────────────────────────────────┐
│ 1. Voice Synthesis (MP3 Audio)                              │
│ - Service: ElevenLabs API (elevenLabsService.js)            │
│ - User input: Text / Dialogue Script                        │
│ - Output: Real human voice audio stream (MP3)               │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ 2. Visual / Image Synthesis (JPG/PNG)                       │
│ - Free / Keyless Engine: Pollinations.ai (image.pollinations│
│   .ai/prompt/{prompt}?width=1280&height=720&nologo=true)   │
│ - Production Engine: OpenAI DALL-E 3 / Stability AI         │
│ - Output: 4K Commercial visual / Logo preview               │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ 3. Video Synthesis (MP4 Video)                              │
│ - Workflow: Gemini se 4-shot storyboard generate hoga       │
│ - Production API: Kling AI / RunwayML API                   │
│ - Output: Real motion video clip                            │
└─────────────────────────────────────────────────────────────┘
```

---

## 7. Custom Python Microservice (In `Al-Models/` Folder - Optional)

Agar future me aapko **apna custom Python model** (e.g. PyTorch, HuggingFace transformers, local Whisper for speech-to-text) run karna ho, to structure aisa hoga:

```
d:/Kiaan/crm-enrgy-jonny/
  ├── Al-Models/
  │     ├── main.py (FastAPI Server on Port 8000)
  │     ├── requirements.txt (fastapi, uvicorn, torch, transformers)
  │     └── model_loader.py (Loads PyTorch weights)
  ├── backend/ (Node.js on Port 5002 - Calls FastAPI via axios)
  └── frontend/ (React on Port 5173)
```

**FastAPI Flow (`Al-Models/main.py`):**
```python
from fastapi import FastAPI
from pydantic import BaseModel
import torch

app = FastAPI()

class PromptRequest(BaseModel):
    prompt: str

@app.post("/custom-predict")
def predict(req: PromptRequest):
    # PyTorch / HuggingFace model inference here
    return {"prediction": "Custom Model Result"}
```
Node.js backend is internal URL (`http://127.0.0.1:8000/custom-predict`) ko call karke frontend ko result de dega.

---

## 8. Step-by-Step Execution Plan (Aage Kya Karna Hai)

1. **Step 1:** [Google AI Studio](https://aistudio.google.com/) se free API key lekar [backend/.env](file:///d:/Kiaan/crm-enrgy-jonny/backend/.env) me paste karein (`GEMINI_API_KEY=...`).
2. **Step 2:** Backend me `aiService.js`, `aiController.js`, aur `aiRoutes.js` create karke [backend/src/app.js](file:///d:/Kiaan/crm-enrgy-jonny/backend/src/app.js) me connect karein.
3. **Step 3:** Backend ko test karein terminal me:
   ```bash
   curl -X POST http://localhost:5002/api/ai/generate -H "Content-Type: application/json" -d "{\"prompt\":\"Hello AI\"}"
   ```
4. **Step 4:** Frontend ke [geminiService.js](file:///d:/Kiaan/crm-enrgy-jonny/frontend/src/services/geminiService.js) ko backend endpoint se link karein.
5. **Step 5:** Browser me [CrmAiStudio.jsx](file:///d:/Kiaan/crm-enrgy-jonny/frontend/src/pages/crm/CrmAiStudio.jsx) aur [BestieAi.jsx](file:///d:/Kiaan/crm-enrgy-jonny/frontend/src/pages/crm/ai/BestieAi.jsx) open karke live prompts test karein!
