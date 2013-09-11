(function() {
  if (typeof window.janrain !== 'object') window.janrain = {};
  window.janrain.settings = {};
  window.janrain.settings.capture = {};

  janrain.settings.appUrl = 'https://codescouts-dev.rpxnow.com';

  janrain.settings.capture.redirectUri = 'https://codescouts-dev.janraincapture.com';
  janrain.settings.capture.appId = 'dtdggxejjsvuhvfeqy59gn5dr2';
  janrain.settings.capture.clientId = 'b7ceaax84qmqch6ampjugwzscf7zyubq';
  janrain.settings.capture.recaptchaPublicKey = '6LeVKb4SAAAAAGv-hg5i6gtiOV4XrLuCDsJOnYoP';
  janrain.settings.capture.responseType = 'token';
  janrain.settings.capture.captureServer = 'https://codescouts-dev.janraincapture.com';
  janrain.settings.capture.transactionTimeout = 100;
  janrain.settings.capture.flowVersion = '47917eba-c22d-4b93-9a58-071f9a5086c2';
  janrain.settings.capture.flowName = 'signinFlow';
  janrain.settings.capture.stylesheets = [];
  janrain.settings.capture.mobileStylesheets = [];

  janrain.settings.capture.keepProfileCookieAfterLogout = true;
  janrain.settings.capture.setProfileCookie = true;
  janrain.settings.type = 'embed';
  janrain.settings.fontFamily = 'Helvetica, Lucida Grande, Verdana, sans-serif';
  janrain.settings.tokenUrl = '';
  janrain.settings.tokenAction = 'event';
  janrain.settings.format = 'one column';
  janrain.settings.providers = ['facebook','google','twitter'];
  janrain.settings.providersPerPage = 4;
  janrain.settings.actionText = ' ';
  janrain.settings.width = 300;
  janrain.settings.borderColor = '#ffffff';
  janrain.settings.backgroundColor = '#ffffff';
  janrain.settings.language = 'en';

  janrain.settings.capture.modalBorderOpacity = 1;
  janrain.settings.capture.modalBorderWidth = 5;
  janrain.settings.capture.modalBorderRadius = 5;
  janrain.settings.capture.modalCloseHtml = '<span class="janrain-icon-16 janrain-icon-ex2"></span>';
  janrain.settings.capture.modalBorderColor = '#7AB433';
  janrain.settings.capture.noModalBorderInlineCss = true;

  janrain.settings.packages = ['login', 'capture'];

  var e = document.createElement('script');
  e.type = 'text/javascript';
  e.id = 'janrainAuthWidget';

  var url = document.location.protocol === 'https:' ? 'https://' : 'http://';
  url += 'd16s8pqtk4uodx.cloudfront.net/signin/load.js';
  e.src = url;
  var s = document.getElementsByTagName('script')[0];
  s.parentNode.insertBefore(e, s);
})();

$(document).ready(function() {
  janrain.ready = true;

  $('#signInButton').click(function() {
    $('#janrainModal').show();
  });
});

function janrainCaptureWidgetOnLoad() {
  janrain.capture.ui.start();
}

