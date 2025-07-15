// USER.JS FROM brainfucksec

// Disable about:config warning
user_pref("browser.aboutConfig.showWarning", false);

/* Set startup home page:
 * 0 = blank
 * 1 = home
 * 2 = last visited page
 * 3 = resume previous session */
user_pref("browser.startup.page",  1);

/* Set Home + New Window page:
 * about:home = Firefox Home (default)
 * about:blank = custom URL */
user_pref("browser.startup.homepage", "about:home");

/* Set NEWTAB page:
 * true = Firefox Home (default), false = blank page */
user_pref("browser.newtabpage.enabled", false);

// Disable sponsored content on Firefox Home (Activity Stream)
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);

// Sponsored shortcuts: clear default topsites
user_pref("browser.newtabpage.activity-stream.default.sites", "");

/*********************************************************************
 * GEOLOCATION
 *********************************************************************/

// Disable using the OS’s geolocation service
user_pref("geo.provider.ms-windows-location", false); // [Windows]
user_pref("geo.provider.use_corelocation", false);    // [macOS]
user_pref("geo.provider.use_geoclue", false);         // [Linux]

/*********************************************************************
 * LANGUAGE / LOCALE
 *********************************************************************/

// Set language for displaying web pages:
user_pref("intl.accept_languages", "en-US, en");
user_pref("javascript.use_us_english_locale", true); // [HIDDEN PREF]

/*********************************************************************
 * RECOMMENDATIONS
 *********************************************************************/

// Disable recommendation pane in about:addons (use Google Analytics)
user_pref("extensions.getAddons.showPane", false); // [HIDDEN PREF]

// Disable recommendations in about:addons Extensions and Themes panes
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);

// Disable personalized Extension Recommendations in about:addons
user_pref("browser.discovery.enabled", false);

/*********************************************************************
 * TELEMETRY
 *********************************************************************/

// Disable Firefox Home (Activity Stream) telemetry
user_pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
user_pref("browser.newtabpage.activity-stream.telemetry", false);

// Disable new data submission
user_pref("datareporting.policy.dataSubmissionEnabled", false);

// Disable Health Reports
user_pref("datareporting.healthreport.uploadEnabled", false);

// Disable telemetry
user_pref("toolkit.telemetry.enabled", false); // [Default: false]
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.server", "data:,");
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false); // bhr = Background Hang Reporter
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
user_pref("toolkit.telemetry.coverage.opt-out", true); // [HIDDEN PREF]
user_pref("toolkit.coverage.opt-out", true); // [HIDDEN PREF]
user_pref("toolkit.coverage.endpoint.base.", "");

/*********************************************************************
 * STUDIES
 *********************************************************************/

// Disable studies
user_pref("app.shield.optoutstudies.enabled", false);

// Disable normandy/shield (telemetry system), https://mozilla.github.io/normandy/
user_pref("app.normandy.enabled", false);
user_pref("app.normandy.api_url", "");

/*********************************************************************
 * CRASH REPORTS
 *********************************************************************/

// Disable crash reports
user_pref("breakpad.reportURL", "");
user_pref("browser.tabs.crashReporting.sendReport", false);

/*********************************************************************
 * NETWORK: DNS, PROXY, NETWORK CHECKS
 *********************************************************************/

// Disable link prefetching
user_pref("network.prefetch-next", false);

// Disable DNS prefetching
user_pref("network.dns.disablePrefetch", true);
user_pref("network.dns.disablePrefetchFromHTTPS", true);

// Disable predictor
user_pref("network.predictor.enabled", false);

// Disable link-mouseover opening connection to linked server
user_pref("network.http.speculative-parallel-limit", 0);

// Disable mousedown speculative connections on bookmarks and history
user_pref("browser.places.speculativeConnect.enabled", false);

/* Disable "GIO" protocols as a potential proxy bypass vectors
 * https://en.wikipedia.org/wiki/GVfs
 * https://en.wikipedia.org/wiki/GIO_(software) */
user_pref("network.gio.supported-protocols", ""); // [HIDDEN PREF]

// Disable using UNC (Uniform Naming Convention) paths (prevent proxy bypass)
user_pref("network.file.disable_unc_paths", true); // [HIDDEN PREF]

// Remove special permissions for certain mozilla domains
user_pref("permissions.manager.defaultsUrl", "");

// Use Punycode in Internationalized Domain Names to eliminate possible spoofing
user_pref("network.IDN_show_punycode", true);

// Disable captive portal detection
user_pref("captivedetect.canonicalURL", "");
user_pref("network.captive-portal-service.enabled", false);

// Disable network connections checks
user_pref("network.connectivity-service.enabled", false);


/*********************************************************************
 * PASSWORDS
 *********************************************************************/

// Disable saving passwords
user_pref("signon.rememberSignons", false);

// Disable formless login capture for Password Manager
user_pref("signon.formlessCapture.enabled", false);

/* Hardens against potential credentials phishing:
 * 0 = don't allow sub-resources to open HTTP authentication credentials dialogs
 * 1 = don't allow cross-origin sub-resources to open HTTP authentication credentials dialogs
 * 2 = allow sub-resources to open HTTP authentication credentials dialogs (default) */
user_pref("network.auth.subresource-http-auth-allow", 1);

/*********************************************************************
 * DISK CACHE / MEMORY
 *********************************************************************/

// Disable disk cache
user_pref("browser.cache.disk.enable", false);

// Disable media cache from writing to disk in Private Browsing
user_pref("browser.privatebrowsing.forceMediaMemoryCache", true);
user_pref("media.memory_cache_max_size", 65536);

// Disable automatic Firefox start and session restore after reboot [Windows]
user_pref("toolkit.winRegisterApplicationRestart", false);

// Disable page thumbnail collection
user_pref("browser.pagethumbnails.capturing_disabled", true); // [HIDDEN PREF]

// Delete temporary files opened from non-Private Browsing windows with external apps
user_pref("browser.download.start_downloads_in_tmp_dir", true);
user_pref("browser.helperApps.deleteTempFileOnExit", true);

/*********************************************************************
 * HTTPS (SSL/TLS, OSC, CERTS)
 *********************************************************************/

// Disable TLS 1.3 0-RTT (round-trip time)
user_pref("security.tls.enable_0rtt_data", false);

// Set OCSP to terminate the connection when a CA isn't validate
user_pref("security.OCSP.require", true);

// Display advanced information on Insecure Connection warning pages
user_pref("browser.xul.error_pages.expert_bad_cert", true);

/* HPKP (HTTP Public Key Pinning) Enable strict PKP (Public Key Pinning):
 * 0 = disabled
 * 1 = allow user MiTM (i.e. your Antivirus)
 * 2 = strict */
user_pref("security.cert_pinning.enforcement_level", 2);

/* Enable CRLite
 * 0 = disabled
 * 1 = consult CRLite but only collect telemetry
 * 2 = consult CRLite and enforce both "Revoked" and "Not Revoked" results
 * 3 = consult CRLite and enforce "Not Revoked" results, but defer to OCSP for "Revoked" (default) */
user_pref("security.remote_settings.crlite_filters.enabled", true);
user_pref("security.pki.crlite_mode", 2);

// Enable HTTPS-Only mode in all windows
user_pref("dom.security.https_only_mode", true);

// Disable sending HTTP request for checking HTTPS support by the server
user_pref("dom.security.https_only_mode_send_http_background_request", false);

/*********************************************************************
 * HEADERS / REFERERS
 *********************************************************************/

/* Control the amount of information to send:
 * 0 = send full URI (default):  https://example.com:8888/foo/bar.html?id=1234
 * 1 = scheme+host+port+path:    https://example.com:8888/foo/bar.html
 * 2 = scheme+host+port:         https://example.com:8888 */
user_pref("network.http.referer.XOriginTrimmingPolicy", 2);

/*********************************************************************
 * AUDIO/VIDEO: WebRTC, WebGL
 *********************************************************************/

// Force WebRTC inside the proxy
user_pref("media.peerconnection.ice.proxy_only_if_behind_proxy", true);

/* Force a single network interface for ICE candidates generation
 * https://wiki.mozilla.org/Media/WebRTC/Privacy */
user_pref("media.peerconnection.ice.default_address_only", true);

// Force exclusion of private IPs from ICE candidates
user_pref("media.peerconnection.ice.no_host", true);

// Disable WebGL (Web Graphics Library):
user_pref("webgl.disabled", true);

/*********************************************************************
 * DOWNLOADS
 *********************************************************************/

// Always ask you where to save files:
user_pref("browser.download.useDownloadDir", false);

// Disable adding downloads to system's "recent documents" list
user_pref("browser.download.manager.addToRecentDocs", false);

// Enable user interaction for security by always asking how to handle new mimetypes:
user_pref("browser.download.always_ask_before_handling_new_types", true);

/*********************************************************************
 * COOKIES
 *********************************************************************/

/*
 * Enable ETP (Enhanced Tracking Protection)
 * ETP strict mode enables Total Cookie Protection (TCP)
 */
user_pref("browser.contentblocking.category", "strict"); // [HIDDEN PREF]

/*********************************************************************
 * UI FEATURES
 *********************************************************************/

// Limit events that can cause a popup
user_pref("dom.popup_allowed_events", "click dblclick mousedown pointerdown");

// Disable PDFJS scripting
user_pref("pdfjs.enableScripting", false);

/* Enable Containers and show the UI settings
 * https://wiki.mozilla.org/Security/Contextual_Identity_Project/Containers */
user_pref("privacy.userContext.enabled", true);
user_pref("privacy.userContext.ui.enabled", true);

/*********************************************************************
 * EXTENSIONS
 *********************************************************************/

/* Limit allowed extension directories:
 * 1 = profile
 * 2 = user
 * 4 = application
 * 8 = system
 * 16 = temporary
 * 31 = all
 * The pref value represents the sum: e.g. 5 would be profile and application directories. */
user_pref("extensions.enabledScopes", 5); // [HIDDEN PREF]

// Display always the installation prompt
user_pref("extensions.postDownloadThirdPartyPrompt", false);



/*********************************************************************
 * FINGERPRINTING (RFP)
 *********************************************************************/

/* RFP (Resist Fingerprinting):
 * RFP can cause some website breakage: mainly canvas, use a site exception via
 * the urlbar.
 *
 * RFP also has a few side effects: mainly timezone is UTC0, and websites will
 * prefer light theme.
 * See: https://bugzilla.mozilla.org/418986
 * https://support.mozilla.org/en-US/kb/firefox-protection-against-fingerprinting */

// Enable RFP
user_pref("privacy.resistFingerprinting", true);

// Increase the size of new RFP windows for better usability
user_pref("privacy.window.maxInnerWidth", 1600);
user_pref("privacy.window.maxInnerHeight", 900);
user_pref("privacy.resistFingerprinting.letterboxing", false);

// Disable mozAddonManager Web API
user_pref("privacy.resistFingerprinting.block_mozAddonManager", true);

/* Disable RFP spoof english prompt:
    * 0 = prompt
    * 1 = disabled
    * 2 = enabled */
user_pref("privacy.spoof_english", 1);

// Set all open window methods to abide by "browser.link.open_newwindow"
user_pref("browser.link.open_newwindow.restriction", 0);