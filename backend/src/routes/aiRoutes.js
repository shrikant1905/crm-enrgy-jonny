const express = require('express');
const router = express.Router();
const aiController = require('../controllers/aiController');

// Status & diagnostics: GET /api/ai/status
router.get('/status', aiController.getStatus);

// Primary Generation Endpoint: POST /api/ai/generate
router.post('/generate', aiController.generateContent);

module.exports = router;

