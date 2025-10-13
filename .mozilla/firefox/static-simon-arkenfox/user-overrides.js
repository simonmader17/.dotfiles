/** custom override **/

/** Search **/
user_pref("browser.search.separatePrivateDefault", false);

/** History **/
user_pref("privacy.clearHistory.browsingHistoryAndDownloads", false);
user_pref("privacy.clearHistory.formdata", false);
user_pref("privacy.clearOnShutdown_v2.browsingHistoryAndDownloads", false);
user_pref("privacy.clearOnShutdown_v2.downloads", false);
user_pref("privacy.clearOnShutdown_v2.formdata", false);
user_pref("privacy.clearSiteData.browsingHistoryAndDownloads", false);
user_pref("privacy.clearSiteData.formdata", false);

/** POCKET ***/
user_pref("extensions.pocket.enabled", false);

/** homepage and new tab page **/
user_pref("browser.startup.page", 1);
user_pref("browser.startup.homepage", "about:home");
user_pref("browser.newtabpage.enabled", true);

/** Styling and userChrome.css stuff **/
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true); // to unlock custom CSS
user_pref("browser.uidensity", 1);
user_pref("widget.gtk.overlay-scrollbars.enabled", false);

/** MOZILLA UI (from Betterfox) ***/
user_pref("browser.privatebrowsing.vpnpromourl", "");
user_pref("extensions.getAddons.showPane", false);
user_pref("extensions.htmlaboutaddons.recommendations.enabled", false);
user_pref("browser.discovery.enabled", false);
user_pref("browser.shell.checkDefaultBrowser", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false);
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false);
user_pref("browser.preferences.moreFromMozilla", false);
user_pref("browser.aboutConfig.showWarning", false);
user_pref("browser.aboutwelcome.enabled", false);
user_pref("browser.tabs.tabmanager.enabled", false);
user_pref("browser.profiles.enabled", true);

/** Middle-click mouse behavior **/
user_pref("general.autoScroll", true);
user_pref("middlemouse.paste", false);

/** other **/
// user_pref("svg.context-properties.content.enabled", true);
// user_pref("userchrome.curved_tabs.flipped-curve.enabled", false);

/** Move disk cache to RAM **/
user_pref("browser.cache.disk.enable", true);
user_pref("browser.cache.disk.parent_directory", "/run/user/1000/firefox");
user_pref("browser.cache.memory.enable", true);
