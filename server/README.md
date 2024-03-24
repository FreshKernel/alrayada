# Alrayada Backend

TODO: Optimize the server database operations performance by getting only what we need, for example in the sendNotificationsToUser
route, by getting only what we need (userDeviceNotifications property in this case), there is no need to get the whole user, take a look 
at the usages of findUserById() and findUserByEmail()
