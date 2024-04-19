const functions = require("firebase-functions");

// const stripe = require("stripe")("sk_test_51LCR7AKoEwOhE0oQ5Q5Uw7Y15LYQtjleokk3icmddmmGrvj9dTPwBs6sdg45HaJR4yc0nf9i43yJtuivdPhGLCUw006tuOn0YS");
const stripe = require("stripe")("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");
const admin = require('firebase-admin');
const fetch = require('node-fetch');
const FieldValue = require('firebase-admin').firestore.FieldValue;
admin.initializeApp(functions.config().firebase);
const database = admin.firestore();
// const createNotificationx = functions.region('us-central1').httpsCallable('createNotification');
exports.stripePaymentIntentRequest = functions.https.onRequest(async (req, res) => {
    try {
        let customerId;


        const customerList = await stripe.customers.list({
            email: req.body.email,
            limit: 1
        });


        if (customerList.data.length !== 0) {
            customerId = customerList.data[0].id;
        }
        else {
            const customer = await stripe.customers.create({
                email: req.body.email
            });
            customerId = customer.data.id;
        }
 

        const ephemeralKey = await stripe.ephemeralKeys.create(
            { customer: customerId },
            { apiVersion: '2020-08-27' }
        );


        const paymentIntent = await stripe.paymentIntents.create({
            amount: parseInt(req.body.amount),
            currency: 'usd',
            customer: customerId,
        })

        res.status(200).send({
            paymentIntent: paymentIntent.client_secret,
            ephemeralKey: ephemeralKey.secret,
            customer: customerId,
            success: true,
        })

    } catch (error) {
        res.status(404).send({ success: false, error: error.message })
    }
});


exports.scheduledFunction = functions.pubsub.schedule('every 12 hours').onRun(async (context) => {

    const batch = admin.firestore().batch();
    console.log('### Started ###');
    const categorySnap = await admin.firestore().collection('questions').doc('qCat').get();
    const qcat = categorySnap.data()['qcat'];
    const pqcat = categorySnap.data()['pqcat'];
    const qcatlength = qcat.length;
    const pqcatlength = pqcat.length;
    const qcatPercentage = 100 / qcatlength;
    const pqcatPercentage = 100 / pqcatlength;
    let batchCount = 0;
    const answersDocumentsSnap = await admin.firestore().collection('answers').get();
    const answersDocs = answersDocumentsSnap.docs;
    const Matches = [];

    try {
        console.log('Started Here');
        answersDocs.forEach(async (userDoc) => {
            ///
            const snap = await admin.firestore().collection('musers').doc(userDoc.id).collection('matches').get();
            const userMatchesSnapDocs = snap.docs;
            const userMatchesIds = userMatchesSnapDocs.map((doc) => doc['userId']) || [];
            if (userDoc.data()['isCompleteProfile'] == true) {
                console.log(`### userDoc ${userDoc.id} ###`);

                const aboutHim = [];
                const aboutHisPartner = [];
                var userAnswerssnap = await userDoc.ref.collection('answers').get();
                const useranswersDocs1 = userAnswerssnap.docs;
                useranswersDocs1.forEach((doc) => {
                    if (qcat.includes(doc.get('cat'))) {
                        aboutHim.push(doc);
                    } else {
                        aboutHisPartner.push(doc);
                    }
                });
                answersDocs.forEach(async (userDoc1) => {
                    if (userDoc1.id != userDoc.id) {
                        if (userMatchesIds.includes(userDoc1.id) == false) {
                            if (userDoc1['isCompleteProfile'] == true) {
                                console.log(`### userDoc ${userDoc1.id} ###`);
                                console.log('### phase1 ###');
                                var snap1 = await admin.firestore().collection('musers').doc(userDoc.id).collection('matches').get();
                                var userMatchesSnapDocs1 = snap1.docs;
                                var userMatchesIds1 = userMatchesSnapDocs1.map((doc) => doc['userId']) || [];
                                console.log('### ${userMatchesIds1} ###');
                                console.log('### phase2 ###');
                                var aboutHim1 = [];
                                var aboutHisPartner1 = [];
                                var userAnswerssnap1 = await userDoc1.reference.collection('answers').get();
                                var useranswersDocs2 = userAnswerssnap1.docs;
                                useranswersDocs1.forEach((doc) => {

                                    if (qcat.includes(doc.get('cat'))) {
                                        aboutHim1.add(doc);
                                    } else {
                                        aboutHisPartner1.add(doc);
                                    }
                                });
                                var totalSimilarityforUser2 = 0.0;
                                var totalSimilarityforUser2list = [];
                                ///
                                var totalSimilarityforFirstUser = 0.0;
                                var totalSimilarityforFirstUserlist = [];
                                console.log('### phase3 ###');
                                pqcat.forEach((category) => {
                                    var percentage = 0.0;
                                    var totalCategoryDocs = 0;
                                    aboutHisPartner1.forEach((himdoc) => {

                                        if (himdoc.get('cat').toString().trim() == category) {
                                            totalCategoryDocs += 1;
                                            aboutHim.forEach((partnerdoc) => {
                                                if (partnerdoc.get('question') == himdoc.get('question')) {
                                                    if (partnerdoc.get('type') == 0 || partnerdoc.get('type') == 1) {
                                                        if ((partnerdoc.get('answer') - himdoc.get('answer')) <= 8) {
                                                            percentage += 1;
                                                        }
                                                    } else if (partnerdoc.get('type') == 2 || partnerdoc.get('type') == 5 || partnerdoc.get('type') == 6 || partnerdoc.get('type') == 7) {
                                                        var partnerAnswers = partnerdoc.get('answer');
                                                        var himAnswers = himdoc.get('answer');
                                                        var isMatched = false;
                                                        if (partnerAnswers.includes(null)) {
                                                            partnerAnswers.remove(null);
                                                        }
                                                        if (himAnswers.includes(null)) {
                                                            himAnswers.remove(null);
                                                        }
                                                        partnerAnswers.forEach((partnerAnswer) => {
                                                            himAnswers.forEach((himAnswer) => {

                                                                if (partnerAnswer.trim() == himAnswer.trim()) {
                                                                    print('Partner Answer: $partnerAnswer    Him Answer: $himAnswer');
                                                                    isMatched = true;

                                                                }
                                                            });
                                                        });
                                                        if (isMatched == true) {
                                                            percentage += 1;
                                                        }
                                                        print(isMatched);
                                                    }
                                                }
                                            });
                                        }
                                    });
                                    console.log('### phase4 ###');
                                    console.log(`### ${totalSimilarityforUser2list} ###`);
                                    totalSimilarityforUser2list.add((percentage.toDouble() / totalCategoryDocs.toDouble()) * 100.00);
                                });
                                console.log('### phase5 ###');
                                pqcat.forEach((category) => {
                                    var percentage = 0.0;
                                    var totalCategoryDocs = 0;
                                    aboutHisPartner.forEach((himdoc) => {

                                        if (himdoc.get('cat').toString().trim() == category) {
                                            totalCategoryDocs += 1;
                                            aboutHim1.forEach((partnerdoc) => {
                                                if (partnerdoc.get('question') == himdoc.get('question')) {
                                                    if (partnerdoc.get('type') == 0 || partnerdoc.get('type') == 1) {

                                                        if ((partnerdoc.get('answer') - himdoc.get('answer')) <= 8) {
                                                            percentage += 1;
                                                        }
                                                    } else if (partnerdoc.get('type') == 2 || partnerdoc.get('type') == 5 || partnerdoc.get('type') == 6 || partnerdoc.get('type') == 7) {
                                                        var partnerAnswers = partnerdoc.get('answer');
                                                        var himAnswers = himdoc.get('answer');
                                                        var isMatched = false;
                                                        if (partnerAnswers.includes(null)) {
                                                            partnerAnswers.remove(null);
                                                        }
                                                        if (himAnswers.includes(null)) {
                                                            himAnswers.remove(null);
                                                        }
                                                        partnerAnswers.forEach((partnerAnswer) => {
                                                            himAnswers.forEach((himAnswer) => {

                                                                if (partnerAnswer.trim() == himAnswer.trim()) {
                                                                    print('Partner Answer: $partnerAnswer    Him Answer: $himAnswer');
                                                                    isMatched = true;

                                                                }
                                                            });
                                                        });
                                                        if (isMatched == true) {
                                                            percentage += 1;
                                                        }
                                                        print(isMatched);
                                                    }
                                                }
                                            });
                                        }
                                    });
                                    console.log('### phase6 ###');
                                    console.log('### ${totalSimilarityforFirstUserlist} ###');
                                    totalSimilarityforFirstUserlist.add((percentage.toDouble() / totalCategoryDocs.toDouble()) * 100.00);
                                });

                                totalSimilarityforUser2 = getTotalSimilarities(totalSimilarityforUser2list);
                                totalSimilarityforFirstUser = getTotalSimilarities(totalSimilarityforFirstUserlist);
                                print(totalSimilarityforUser2.round());
                                print(totalSimilarityforFirstUser.round());
                                const uid1 = Uuid().v1();
                                const uid2 = Uuid().v1();
                                console.log('user1 similarity: ${totalSimilarityforFirstUser}}');
                                console.log('user2 similarity: ${totalSimilarityforUser2}}');

                                batch.set(admin.firestore().collection('musers').doc(userDoc1.id).collection('matches').doc(uid1), {
                                    'Similarity': totalSimilarityforUser2.toStringAsFixed(2),
                                    'date': DateTime.now(),
                                    'matchId': uid1,
                                    'saw': false,
                                    'userId': userDoc.id,

                                });
                                batchCount += 1;


                                batch.set(admin.firestore().collection('musers').doc(userDoc.id).collection('matches').doc(uid2), {
                                    'Similarity': totalSimilarityforFirstUser.toStringAsFixed(2),
                                    'date': DateTime.now(),
                                    'matchId': uid2,
                                    'saw': false,
                                    'userId': userDoc1.id,

                                });
                                batchCount += 1;
                                if (batchCount >= 490) {
                                    await batch.commit();
                                }
                            }
                        }
                    }
                })

            }
        })

    } catch (error) {
        console.log('Error');
        console.log(error.toString());
        console.log('Error');
    }

    await batch.commit();

});
exports.sendNotification = functions.firestore.document('musers/{userId}/notifications/{notificationId}')
    .onCreate(async (snapshot, context) => {
        ``

        // Get the user's token and isActive field from their user document
        const userId = context.params.userId;
        const userDocRef = admin.firestore().collection('musers').doc(userId);
        const userDoc = await userDocRef.get();

        // Check if the token and isActive fields exist in the user's document
        const token = userDoc.get('token');
        const isActive = userDoc.get('isActive');
        if (!token || !isActive) {
            console.log(`User ${userId} is not active or does not have a valid token, skipping notification`);
            return null;
        }

        // Get the text of the notification
        const notificationText = snapshot.get('text');

        // Set the message payload

        const payload = {
            "notification": {
                "title": 'مدله: شريكك المناسب',
                "body": notificationText,
                "sound": "default"
            },
            "data": {
                "sendername": 'MaDaLh',
                "message": "إشعار"
            }
        }

        // Send the message to the user's device using their notification token
        const response = await admin.messaging().sendToDevice(token, payload);

        // Check for errors or other issues with sending the message
        const errors = [];
        response.results.forEach((result, index) => {
            const error = result.error;
            if (error) {
                errors.push({ index, error });
            }
        });

        // Log the response from sending the message, including any errors
        console.log(`Notification sent to ${response.successCount} devices with ${errors.length} errors:`);
        errors.forEach((error) => {
            console.log(`- Device ${error.index} failed with error: ${error.error}`);
        });

        return null;
    });
exports.dailyFunction = functions.pubsub.schedule('every 24 hours').onRun(async (context) => {

    const usersCollection = admin.firestore().collection('musers');
    const usersSnapshot = await usersCollection.get();

    usersSnapshot.forEach(async (doc) => {

        const userId = doc.id;
        const userData = doc.data();
        const isActive = userData.isActive;
        const isSubscribed = userData.isSubscribed;
        const subscriptionDate = userData.subscriptionDate;
        const gender = userData.gender;

        ///
        const appSettingsRef = admin.firestore().doc('AppSettings/appSettings');
        const appSettingsDoc = await appSettingsRef.get();
        const freeFMatch = appSettingsDoc.get('freeFMatch');
        const freeMatch = appSettingsDoc.get('freeMatch');
        const freeMsg = appSettingsDoc.get('freeMsg');
        ///


        if (!isActive) {
            console.log(`User ${userId} is not active, skipping...`);
            return;
        }

        // Perform some functionality on the user here...
        console.log(`Processing user ${userId}...`);
        // ...
        if (isSubscribed == true) {
            const now = Date.now();
            const daysSinceSubscription = Math.floor((now - subscriptionDate.toMillis()) / (24 * 60 * 60 * 1000));
            if (daysSinceSubscription >= 30) {
                const token = userData.token;
                // do if finished subscrption like a normal user and send notification
                if (gender == 'm') {
                    //For Free Male


                    await usersCollection.doc(userId).update({ matches: freeMatch, isSubscribed: false });
                } else {
                    //For Free Female

                    await usersCollection.doc(userId).update({ fmatches: freeFMatch, messages: freeMsg, isSubscribed: false });
                }
                await createNotificationx({ userId: userId, text: 'لقد انتهى اشتراكك بالباقة يرجى تجديدها للإستفادة من الخدمات المميزة ' });


            } else {
                // do if vip subscrption 
                if (gender == 'm') {
                    //For Male
                    const bundleMatches = userData.bundleMatches;

                    await usersCollection.doc(userId).update({ matches: bundleMatches });
                    await createNotificationx({ userId: userId, text: 'تم تجديد تطابقاتك اليومية' });
                } else {
                    //For Female
                    const bundleMatches = userData.bundleMatches;
                    const bundleMessages = userData.bundleMessages;


                    await usersCollection.doc(userId).update({ fmatches: bundleMatches, messages: bundleMessages });
                    await createNotificationx({ userId: userId, text: 'تم تجديد رسائلك ونكزاتك اليومية' });
                }



            }
        } else {
            // do a normal user
            if (gender == 'm') {
                //For Free Male

                await usersCollection.doc(userId).update({ matches: freeMatch });
                await createNotificationx({ userId: userId, text: 'تم تجديد تطابقاتك اليومية' });

            } else {
                //For Free Female

                await usersCollection.doc(userId).update({ fmatches: freeFMatch, messages: freeMsg });
                await createNotificationx({ userId: userId, text: 'تم تجديد رسائلك ونكزاتك اليومية' });

            }

        }

        // Update the user's document (if necessary) here...
        await usersCollection.doc(userId).update({ lastProcessed: new Date() });

    });


    return null;
});

exports.deleteDuplicateMatchesAndNotify = functions.firestore
    .document('musers/{userId}/matches/{matchId}')
    .onCreate(async (snap, context) => {
        const userId = context.params.userId;
        const matchId = context.params.matchId;
        const matchData = snap.data();
        const userDocRef = admin.firestore().collection('musers').doc(userId);
        // Check if the matchData has a userId field
        if (!matchData.userId) {
            console.log(`Match document ${matchId} does not have a userId field, skipping...`);
            return null;
        }

        const matchesCollection = admin.firestore().collection(`musers/${userId}/matches`);

        // Query for all the matches with the same userId value


        // Delete any matches with the same userId except for the current match
        const batch = admin.firestore().batch();
        // let deletedCount = 0;
        // matchesQuery.forEach((doc) => {
        //     const docId = doc.id;
        //     const docData = doc.data();
        //     if (docData.userId == matchData.userId) {
        //         console.log(`Deleting match document ${docId} with duplicate userId ${matchData.userId}`);
        //         batch.delete(matchesCollection.doc(docId));
        //         deletedCount++;
        //     }
        // });

        // Commit the batched delete operations
        // if (deletedCount > 0) {
        //     await batch.commit();
        // }

        if (matchData.Similarity < 39) {

            await createNotificationx({ userId: userId, text: `لديك تطابقات بين 35% و 39%. معنا ستجد الأفضل` });
        } else {
            await createNotificationx({ userId: userId, text: 'تم الحصول على تطابق جديد' });
        }

        // await admin.firestore().collection(`musers/${userId}/matches`).doc(matchId).set(matchData);
        return null;
    });



exports.sendRequestNotification = functions.firestore
    .document('requests/{requestId}')
    .onUpdate(async (change, context) => {
        const request = change.after.data();

        // Check if the status field has changed
        if (!change.before.exists() || request.recResType !== change.before.data().recResType) {
            // Get the sender and receiver user IDs
            const senderId = request.senId;
            const receiverId = request.recId;

            // Get the sender and receiver user documents
            const senderDoc = await admin.firestore().doc(`musers/${senderId}`).get();
            const receiverDoc = await admin.firestore().doc(`musers/${receiverId}`).get();

            // Check if the sender and receiver documents exist
            if (senderDoc.exists && receiverDoc.exists) {


                // Send a notification to the sender if the request has been accepted
                if (request.recResType == 0) {
                    await createNotificationx({ userId: senderId, text: 'تحديث حالة الطلب: تم الرفض' });
                    await createNotificationx({ userId: receiverId, text: 'تحديث حالة الطلب: تم الرفض' });

                } else if (request.recResType == 1) {

                } else if (request.recResType == 2) {

                } else if (request.recResType == 3) {

                } else if (request.recResType == 4) {

                } else if (request.recResType == 5) {
                    await createNotificationx({ userId: senderId, text: 'تحديث حالة الطلب: لديك سؤال' });

                } else if (request.recResType == 6) {
                    await createNotificationx({ userId: receiverId, text: 'تحديث حالة الطلب: تمت إجابة سؤالك' });

                } else if (request.recResType == 7) {
                    await createNotificationx({ userId: receiverId, text: 'تحديث حالة الطلب: تم رفض سؤالك من الإدارة لديك فرصة أخرى' });



                } else if (request.recResType == 8) {
                    await createNotificationx({ userId: senderId, text: 'تحديث حالة الطلب: تم رفض إجابتك من الإدارة لديك فرصة أخرى' });

                } else if (request.recResType == 9) {
                    await createNotificationx({ userId: receiverId, text: 'تحديث حالة الطلب: تم إنتهاء المدة وتم إخفاء معلومات ولي أمرك' });
                    await createNotificationx({ userId: senderId, text: 'تحديث حالة الطلب: تم إنتهاء المدة وتم إخفاء معلومات ولي امر صاحبة الحساب' });



                }

            }
        }

        return null;
    });
exports.sendMsgNotification = functions.firestore
    .document('messages/{messageId}')
    .onUpdate(async (change, context) => {
        const request = change.after.data();

        // Check if the status field has changed
        if (!change.before.exists() || request.status !== change.before.data().status) {
            // Get the sender and receiver user IDs
            const senderId = request.senId;
            const receiverId = request.recId;

            // Get the sender and receiver user documents
            const senderDoc = await admin.firestore().doc(`musers/${senderId}`).get();
            const receiverDoc = await admin.firestore().doc(`musers/${receiverId}`).get();

            // Check if the sender and receiver documents exist
            if (senderDoc.exists && receiverDoc.exists) {


                // Send a notification to the sender if the request has been accepted
                if (request.recResType == 0) {
                    await createNotificationx({ userId: senderId, text: 'تحديث حالة الرسالة: تم الرفض' });
                    await createNotificationx({ userId: receiverId, text: 'تحديث حالة الرسالة: تم الرفض' });

                } else if (request.recResType == 1) {

                } else if (request.recResType == 2) {
                    await createNotificationx({ userId: senderId, text: 'تحديث حالة الطلب: تم رفض رسالتك من الإدارة لديك فرصة أخرى' });

                } else if (request.recResType == 3) {

                } else if (request.recResType == 4) {
                    await createNotificationx({ userId: receiverId, text: 'تحديث حالة الطلب: تم رفض إجابتك من الإدارة لديك فرصة أخرى' });
                } else if (request.recResType == 5) {
                    await createNotificationx({ userId: receiverId, text: '  تحديث حالة الطلب: لديك رسالة جديدة' });

                } else if (request.recResType == 6) {
                    await createNotificationx({ userId: senderId, text: 'تحديث حالة الطلب: تمت إجابة رسالتك' });

                } else if (request.recResType == 7) {



                } else if (request.recResType == 8) {


                } else if (request.recResType == 9) {

                }

            }
        }

        return null;
    });
async function createNotificationx(data) {
    const userId = data.userId;
    const message = data.text;

    // Get the current timestamp
    const timestamp = new Date();

    // Create a new notification document
    const notificationRef = admin.firestore().collection(`musers/${userId}/notifications`).doc();
    const notificationData = {
        text: message,
        date: timestamp,
        saw: false,
        isDataShared: false,
    };

    // Save the new notification document
    await notificationRef.set(notificationData);

    // console.log(`Notification created for user ${userId} with message: ${message}`);

    return { success: true };
};

exports.checkLastLoginDate = functions.pubsub.schedule('every 24 hours').onRun(async (context) => {
    try {
        const usersSnapshot = await admin.firestore().collection('musers').get();

        usersSnapshot.forEach(async (userDoc) => {
            const lastLoginDate = userDoc.data().lastLoginDate.toDate();
            const currentDate = new Date();

            const timeDiffInHours = Math.abs(currentDate - lastLoginDate) / 36e5;

            if (timeDiffInHours >= 72) {
                // Do something if last login was more than 72 hours ago
                console.log(`User ${userDoc.id} last logged in more than 72 hours ago`);
                await createNotificationx({ userId: userDoc.id, text: 'أين انت؟ هيا لنجد شريكك المناسب' })
            }

            if (timeDiffInHours >= 504) {
                // Do something if last login was more than 3 weeks ago (504 hours)
                await usersCollection.doc(userDoc.id).update({ isActive: false });
            }
        });

        console.log('Check completed successfully');
    } catch (error) {
        console.error('Error checking last login date:', error);
    }
});

// exports.updateQuestion = functions.firestore.document('questions/{questionId}').onUpdate(async (change, context) => {
//     try {
//         const updatedQuestion = change.after.data();
//         const oldQuestion = change.before.data();

//         const questionBefore = oldQuestion['question'];
//         const questionAfter = updatedQuestion['question'];
//         const answerBefore = oldQuestion['availableAnswer'];
//         const answerAfter = updatedQuestion['availableAnswer'];


//         if ((questionBefore == questionAfter) && (answerBefore == answerAfter)) {
//             console.log(`Question ${context.params.questionId} was updated but no relevant fields were changed`);
//         } else {
//             const usersSnapshot = await admin.firestore().collection('musers').get();
//             usersSnapshot.forEach(async (userDoc) => {
//                 await createNotificationx({ userId: userDoc.id, text: 'حدث تحديث على الأسئلة يرجى مراجعة ملفك' });
//             })

//         }
//     } catch (error) {
//         console.error('Error updating question:', error);
//     }
// });