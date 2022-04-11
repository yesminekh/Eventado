const express = require('express');
const router = express.Router();
const eventRegister=require('../controllers/eventRegisterController');

  router.post('/:id', eventRegister.create);


  module.exports = router;