const mongoose = require('mongoose')



const eventSchema = new mongoose.Schema({

    name: {
        type: String,
        required: true
    },
    date: {
        type: String
    },
    nbrMax: {
        type: Number
    },
    Price: {
        type: Number
    },
    organizer: {
        type: String
    },
    participants: [{ type: mongoose.Schema.ObjectId, ref: "User" }],
    description: {
        type: String
    },
    Affiche: {
        type: String
    }

})

module.exports = mongoose.model('event', eventSchema)