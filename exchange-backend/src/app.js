const express = require('express')
const bodyParser = require('body-parser')
const cors = require('cors')
const helmet = require('helmet')
const morgan = require('morgan')
const config = require("./config");
const stripe = require("stripe")(config.stripeKey);
const cryptoLib = require("./cryptoLib");

const app = express()

app.use(cors())
app.use(helmet())
app.use(morgan('tiny'))
app.use(bodyParser.json())

app.post('/payment', async (req, res) => {

    try {
        console.log(req.body);
        const customer = await stripe.customers.create({
            email: req.body.email, // customer email
            source: req.body.token // token for the 
        });
        const charges = await stripe.charges.create({ // charge the customer
            amount: req.body.price * 100,
            description: "Token Purchase",
            currency: "usd",
            customer: customer.id
        })
        await cryptoLib.sendTokens(req.body.ethAddress, req.body.number); // transfer tokens to customer's wallet

        return res.status(200).json({ message: "Transaction Complete!" })
    } catch (err) {
        return res.status(400).json({ message: "Payment Failed.", error: err });
    }

})

module.exports = app