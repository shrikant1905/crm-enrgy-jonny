/**
 * CRM nErgy AI — Universal AI Service
 * Supports Local Ollama (Qwen2.5-Coder) + Optional Google Gemini Fallback
 */

const OLLAMA_BASE_URL = process.env.OLLAMA_BASE_URL || 'http://127.0.0.1:11434';
const OLLAMA_MODEL = process.env.OLLAMA_MODEL || 'qwen2.5-coder:3b';
const GEMINI_API_KEY = process.env.GEMINI_API_KEY || '';
const GEMINI_MODEL = process.env.GEMINI_MODEL || 'gemini-2.5-flash';

/**
 * Generate AI Content using Local Ollama (Primary) or Gemini (Fallback)
 */
async function generateAiContent({ prompt, systemInstruction = '', model }) {
  const chosenModel = model || OLLAMA_MODEL;

  // 1. Primary Engine: Local Ollama on Server (Free, Fast, Private)
  try {
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 60000); // 60s timeout for CPU inference

    const response = await fetch(`${OLLAMA_BASE_URL}/api/generate`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        model: chosenModel,
        prompt: prompt,
        system: systemInstruction || undefined,
        stream: false,
      }),
      signal: controller.signal,
    });

    clearTimeout(timeout);

    if (response.ok) {
      const data = await response.json();
      if (data && data.response) {
        return {
          success: true,
          engine: 'ollama',
          model: chosenModel,
          text: data.response.trim(),
          timestamp: new Date().toISOString(),
        };
      }
    }
  } catch (ollamaErr) {
    console.warn(`[AiService] Local Ollama not responding (${ollamaErr.message}), checking fallbacks...`);
  }

  // 2. Secondary Engine: Google Gemini Cloud (If API key provided)
  if (GEMINI_API_KEY && GEMINI_API_KEY !== 'your_actual_api_key_here') {
    try {
      const { GoogleGenAI } = require('@google/genai');
      const aiClient = new GoogleGenAI({ apiKey: GEMINI_API_KEY });

      const response = await aiClient.models.generateContent({
        model: GEMINI_MODEL,
        contents: prompt,
        config: {
          systemInstruction: systemInstruction || undefined,
          temperature: 0.7,
          maxOutputTokens: 2048,
        },
      });

      return {
        success: true,
        engine: 'gemini',
        model: GEMINI_MODEL,
        text: response.text || '',
        timestamp: new Date().toISOString(),
      };
    } catch (geminiErr) {
      console.error(`[AiService] Gemini Fallback failed:`, geminiErr.message);
    }
  }

  throw new Error('All AI engines failed or are unreachable.');
}

/**
 * Check AI Engine status
 */
async function checkAiStatus() {
  let ollamaOnline = false;
  let ollamaModels = [];

  try {
    const res = await fetch(`${OLLAMA_BASE_URL}/api/tags`, { method: 'GET' });
    if (res.ok) {
      const data = await res.json();
      ollamaOnline = true;
      ollamaModels = (data.models || []).map((m) => m.name);
    }
  } catch (e) {
    ollamaOnline = false;
  }

  return {
    status: ollamaOnline ? 'online' : 'offline',
    primaryEngine: 'Ollama (Local Server AI)',
    ollamaOnline,
    installedModels: ollamaModels,
    activeModel: OLLAMA_MODEL,
    geminiConfigured: Boolean(GEMINI_API_KEY && GEMINI_API_KEY !== 'your_actual_api_key_here'),
  };
}

module.exports = {
  generateAiContent,
  checkAiStatus,
};

