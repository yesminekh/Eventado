var mongoose = require('mongoose');
const express = require('express');
const Event = require('../models/event');
const User = require('../models/user');
const { count } = require('../models/event');


exports.getAllEvents = async (req, res) => {
    try {
        const events = await Event.find()
        res.json(events)
    } catch (err) {
        res.status(500).json({ message: err.message })
    }
}

exports.createEvent = async (req, res) => {

    const { name, date, nbrMax, description, Affiche, Price,organizer } = req.body;

    const verifEvent = await Event.findOne({ name });
    if (verifEvent) {
        res.status(403).send({ message: "Event already exists !" });
    } else {
        const newEvent = new Event();
        newEvent.name = name;
        newEvent.date = date;
        newEvent.description=description;
        newEvent.Price = Price;
        newEvent.organizer = organizer;
        newEvent.nbrMax=nbrMax;
        newEvent.Affiche = "http://localhost:3001/" + req.file.path
        newEvent.save();
        res.status(201).json({ newEvent });
        
    }
}



exports.updateEvent = async (req, res) => {
    const event = {
      _id: req.params.id,
      ...req.body
    };
    if(req.file){
      event.Affiche = "http://localhost:3001/" + req.file.path;
    }
    console.log(event);
    Event.updateOne({ _id: req.params.id }, event).then(
      () => {
        res.status(201).json({
          message: 'Event updated successfully!',
         event
        });
      }
    ).catch(
      (error) => {
        res.status(400).json({
          error: error
        });
      }
    );
  }


  exports.deleteEvent = async (req, res) => {
    Event.deleteOne({_id: req.params.id}).then(
      () => {
        res.status(200).json({
          message: 'Deleted!'
        });
      }
    ).catch(
      (error) => {res.status(400).json({error: error});
      }
    );
  } 
  
  exports.getEventById = async (req, res) => {
    Event.findById(mongoose.Types.ObjectId(req.params.id)
    , (err, event) => {
      console.log({$month:"$date"})
      res.status(200).json(event);
      return;
    });
  };



  exports.getCountedEventsByYear = async(req,res) =>{ 
    console.log(req.params.year);  
    //Event.aggregate([{ $group: {date : { $regex: '.*'+'-04-'+'.*' }}},
    //{$count:{date: { $regex: '.*' + req.params.year + '.*' }}}], 
    //{"count": {$sum:1}}], 
//Event.countDocuments({ $group: {date : { $regex: '.*'+req.params.year+'-01-'+'.*' }}},
//Event.aggregate([{ $group: {date : { $regex: '.*' + req.params.year +'-04-'+ '.*' },count: { $sum: 1}}}],
Event.aggregate([
  { $project: {
    "nominal": 1, 
    "month": { "$month": "$date" }
  }}, 
  {$group: {
      //_id:"$_id",
      _id: "$month",
      count: { $sum: 1}
  }
}],
(err, events) => {
      res.status(200).json(events);
      console.log(events)
    });
    //console.log(events);  
    //db.collection.aggregate([
    //  { $match: <query> },
    //  { $group: { _id: null, n: { $sum: 1 } } }
   //])

  };

