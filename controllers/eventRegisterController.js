var mongoose = require('mongoose');
const express = require('express');
const event = require('../models/event');
const User = require('../models/user');
const EventRegister = require('../models/eventRegister');
const eventRegister = require('../models/eventRegister');



exports.create = async (req, res) => {
    const event_id =  req.body.event_id;
    const user_id = req.body.user_id;
    const Event = await event.findById(event_id);
   
   
    if (!Event) return res.status(404).send({message : 'Event is not found'})
    const user = await User.findById(user_id);
    if (!user) return res.status(404).send({message :'User is not register'})

    let eventRegister = new EventRegister({
        user: user_id,
        event: event_id
    })

    eventRegister = await eventRegister.save();
   // await eventRegister.populate('event').populate('user', 'f_name username email').exec();
   //await eventRegister.populate('event').populate('participants', 'f_name username email').execPopulate();

    res.send(eventRegister)
}


