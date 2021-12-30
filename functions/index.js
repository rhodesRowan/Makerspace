const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//

exports.sendNotifcation = functions.firestore.document('users/{userID}/notifications/{notificationID}').onCreate((change, context) => {
      var notificationID = context.params.notificationID;
      var currentUser = context.params.userID;

      return admin.firestore().collection("notifications").doc(notificationID)
      .get()
      .then(snapshot => {
          var notificationData = snapshot.data();
          var isRead = notificationData.isRead;
          var text = notificationData.text;
          var user = notificationData.userID;

          if (isRead) {
            return console.log("The user has already read the notification");
          }

          // get others users name
          return admin.firestore().collection("users").doc(user)
          .get()
          .then(snapshot => {
            var usersData = snapshot.data();
            var usersName = usersData.displayName;

            // get current users tokens
            return admin.firestore().collection("users").doc(currentUser)
            .get()
            .then(snapshot => {
              var currentUserData = snapshot.data();
              var currentUserTokens = currentUserData.tokens;
              const payload = {
                  notification: {
                      title: 'Makerspace',
                      body: usersName + " " + text
                  },
                  apns: {
                    payload: {
                      aps: {
                        badge: 1,
                      },
                    },
                  },
                  android:{
                    'notification':{
                      'notificationCount': 1,
                    },
                  },
                  tokens: currentUserTokens
             };
              // send notification
              return admin.messaging().sendMulticast(payload);
            })
            .catch(function(error) {
              console.log("got an error",error);
            });
          })
          .catch(function(error) {
            console.log("got an error",error);
          });

      }).catch(function(error){
          console.log("got an error",error);
      })
});


// clear streaks
exports.removeStreaks = functions.pubsub.schedule('0 * * * *').onRun((context) => {
  var now = new Date();

  return admin.firestore().collection("streaks").get().then((snapShot) => {
    const batch = admin.firestore().batch();
    snapShot.forEach((doc) => {
      if(doc.exists) {
        const streakEnds = new Date(doc.data().streakEnds.toMillis());
        const userID = doc.data().userID;
        var streakCounterRef = admin.firestore().collection("streaks").doc(userID);
        console.log("Time now " + now + ", vs " + streakEnds);
        if (now > streakEnds) {
          batch.set(streakCounterRef, {
            "userID" : userID,
            "count": 0,
            "streakEnds" : now
          });
        }
      } else {
        console.log("doc doesnt exist");
      }
    })

    return batch.commit();
  }).catch((error) => {
    return console.log(error.message);
  });
});
