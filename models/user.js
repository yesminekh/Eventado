const mongoose = require('mongoose')
const bcrypt = require('bcrypt')
const jwt = require('jsonwebtoken')
const crypto = require('crypto')


const UserSchema = new mongoose.Schema({

  f_name: {
    type: String
  },
  username: {
    type: String
  },
  email: {
    type: String
  },
  password: {
    type: String,
  },
  avatar: {
    type: String
  },
  Role: {
    type: String
  },
  isVerified: {
    type: Boolean
  },
  followers: [{ type: mongoose.Schema.ObjectId, ref: "User" }],
  following: [{ type: mongoose.Schema.ObjectId, ref: "User" }]


},


  { timestamps: true })


UserSchema.methods.generatePasswordReset = function () {
  this.resetPasswordToken = crypto.randomBytes(20).toString('hex');
  this.resetPasswordExpires = Date.now() + 3600000; //expires in an hour
};


//mongoose.set('useFindAndModify', false);


module.exports = mongoose.model('User', UserSchema)
