const functions = require('firebase-functions');
const admin = require('firebase-admin')
const stripe = require('stripe')("sk_test_51HtbmNLGVtvBdffSg3qsItHh0aEn7yhmsGiWU6So8mhVxsxbxIZym9x1IHjvZ6nnXkopVsDmN7ywHHqXxHj37cHM00kYschU4p")

admin.initializeApp()

const auth = admin.auth()

exports.createStripeCustomer = functions.https.onCall( async (data, context) => {

  const uid = context.auth.uid
  const email = data.email
  const metadata = data.metadata

  if (uid === null) {
    throw new functions.https.HttpsError('internal', 'Illegal access attempt')
  }

  return stripe.customers.create({description: 'First Test Customer', email: email, metadata: metadata,
  })
  .then(customer => {
  return customer["id"]
  })
  .then( customerId => {
    admin.firestore().collection('users').doc(uid).set(
      {
        stripeId: customerId,
        email: email,
        id: uid
      }
    )
  })
  .catch( error => {
    throw new functions.https.HttpsError('Internal', 'Unable to create Stripe customer')
  })
})

exports.createEphemeralKey = functions.https.onCall(async (data, context) => {

  const customerId = data.customer_id;
  const stripeVersion = data.stripe_version;
  const uid = context.auth.uid;

  if (uid == null) {
    console.log('Illegal access attempt due to unauthenticated user access attempt')
    throw new functions.https.HttpsError('internal', 'Illegal access attempt');
  }

  return stripe.ephemeralKeys.create (
    { customer: customerId },
    { stripe_version: stripeVersion }
  ).then((key) => {
    return key
  }).catch( (error) => {
    functions.logger.log('Error creating ephemeral key', error)
    throw new functions.https.HttpsError('internal', 'Unable to create ephemeral key' + error)
  })

})

exports.createPaymentIntent = functions.https.onCall( async (data, context) => {

  const total = data.total
  const idempotency = data.idempotency
  const customer = data.customer_id

  const uid = context.auth.uid;

  if (uid == null) {
    console.log('Illegal access attempt due to unauthenticated user access attempt')
    throw new functions.https.HttpsError('internal', 'Illegal access attempt');
  }

  return stripe.paymentIntents.create(
    {
      amount: total,
      currency: 'usd',
      customer: customer,
      payment_method_types: ['card', 'ach_debit']
    },
    {
      idempotencyKey: idempotency
    }
  ).then( intent => {
    return intent.client_secret
  }).catch( error => {
    functions.logger.log('Unable to create Stripe Payment Intent')
    return null
  })
})

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions

// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Stephen J Learmonth!");
// });

// exports.deleteUser = functions.https.onRequest( async (request, response) => {

//   const email = request.body.email;
  
//   const user = await auth.getUserByEmail(email).catch( error => {
//     console.log(error)
//     response.status(500).send('Unable to get user', error)
//   })

//   auth.deleteUser(user.uid).then( () => {
//     response.status(200).send('User successfully deleted.')
//   }).catch( error => {
//     response.status(500).send('Error attempting to delete user', error)
//   })
// })

// // OnCreate
// exports.vacationAdded = functions.firestore
//   .document("vacations/{vacationId}")
//   .onCreate((snap) => {

//     // Any time a document is created in the 'vacations' collection, this function will be called.

//     // The firestore document data in a JSON object.
//     const data = snap.data();

//     functions.logger.log('New Vacation: ', data)

//     // Do what you need to do with this data.

//     return null

//   });

// // On Update
// exports.vacationUpdated = functions.firestore
//   .document("vacations/{vacationId}")
//   .onUpdate((change) => {

//     // Any time a document is updated in the 'vacations' collection, this function will be called.

//     // The firestore document object BEFORE.
//     const beforeData = change.before.data()

//     // The firestore document object NOW.
//     const data = change.after.data();

//     functions.logger.log('Old Vacation: ', beforeData)
//     functions.logger.log('New Vacation: ', data)

//     // Do what you need to do with this data.

//     return null

//   });

// // On Delete
// exports.vacationDeleted = functions.firestore
//   .document("vacations/{vacationId}")
//   .onDelete((snap) => {

//     // Any time a document is deleted in the 'vacations' collection, this function will be called.

//     // The firestore document that was just deleted.
//     const data = snap.data();

//     functions.logger.log('Deleted Vacation: ', data)

//     // Do what you need to do with this data.

//     return null

//   });