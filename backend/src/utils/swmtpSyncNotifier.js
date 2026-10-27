/**
 * SWMTP Central Hub Sync Notifier Utility
 * Dispatches real-time synchronization events (Leads, Deals, Contacts)
 * to the SWMTP Central Hub mesh network.
 */

const notifySwmtp = async (eventType, payload = {}) => {
  try {
    const swmtpBaseUrl = process.env.SWMTP_BASE_URL || 'http://127.0.0.1:5000/api/v1';
    const connectorKey = process.env.SWMTP_CONNECTOR_KEY || process.env.CRM_NERGY_CONNECTOR_KEY || 'crm_nergy_live_secret_key_v2_2026';

    // Hook for real-time background sync if enabled
    if (process.env.ENABLE_SWMTP_SYNC === 'true') {
      const syncUrl = `${swmtpBaseUrl.replace(/\/+$/, '')}/internal-chat/integrations/crm-nergy/events`;
      fetch(syncUrl, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'x-platform-api-key': connectorKey,
        },
        body: JSON.stringify({
          event: eventType,
          data: payload,
          timestamp: new Date().toISOString(),
        }),
      }).catch((netErr) => {
        // Safe non-blocking warning when remote hub is offline
        console.warn(`[SWMTP Sync Notifier]: Hub unreachable (${netErr.message})`);
      });
    }

    return { success: true, eventType };
  } catch (err) {
    console.warn(`[SWMTP Sync Notifier Warning]: ${err.message}`);
    return { success: false, error: err.message };
  }
};

module.exports = {
  notifySwmtp,
};
