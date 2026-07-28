function fn() {
  var env = karate.env || 'local';

  var environmentUrls = {
    local: 'http://localhost:3100/api'
  };

  var baseUrl = karate.properties['baseUrl'] || environmentUrls[env];

  if (!baseUrl) {
    throw new Error(
      'No base URL configured for environment: ' + env
    );
  }

  return {
    env: env,
    baseUrl: baseUrl
  };
}