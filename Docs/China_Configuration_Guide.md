# Social login configuration guide for China
Social login servers deployed in China are restricted in various ways, which means that the behavior of this library is restricted as well.

This document explains the differences between the standard configuration and the configuration needed for China.


## The social providers
Standard social login servers depend on the “realm,” a subdomain
established for each social login property. This process is started by
retrieving the social provider configurations through a fixed server URL.  
However, China social login servers don't support the Social Login realm and, instead, are hosted
on different servers with different hostnames. Some configuration parameters may be provided through the janrain_config.plist file to overcome this situation:

* **engageDomain** - This is the base social login server URL, which will overrides the standard `https://rpxnow.com` URL.   
* **applicationId** - This parameter was already mandatory (in release v5.4.2), but it's worth mentioning that the library is now able to attach both `applicationDomain` and `engageDomain` when requesting configurations and when calling the social provider start URL. Attaching this parameter to the start URL overcomes the fact that the Social Login realm isn’t supported.

## Getting the token
Social login retrieves both, the token and the user profile through  
the same sign-in mechanism which starts by calling the providers URL. This  
is achieved by using the `{provider}/token_url=` endpoint as an intermediary.  
After the sign-in is completed the social login server will sends a  
redirect to the provided uURLrl, which is handled by the library.

# Capture Configuration Guide
Capture usually provides the flow configuration file through a CDN (Content Delivery Network) whose
URL is handled inside the library, but for China a different CDN may be
used.
This CDN can be configured through the `janrain_config.plist` file with
the `captureFlowDomain`. This is just the base URL without any paths
referring to the flow file; instead, it's usally includes just the schema and the host name.

# Configuring the same app for both environments
The recommended way to attain this configuration is to provide a second configuration file for China in addition to the default one.  
This results in two configuration files; for example:
* `janrain_config.plist`
* `janrain_config_china.plist`

Of course, you can define any name for either configuration file.
