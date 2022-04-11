const express = require('express');
const router = express.Router();
const eventController = require('../controllers/eventController');
const multer = require('../middleware/multer-config');


router.get('/', eventController.getAllEvents);

router.post('/',multer.single('Affiche'),eventController.createEvent);

router.put('/:id',multer.single('Affiche'),eventController.updateEvent);

router.delete('/:id',eventController.deleteEvent);

router.get('/:id',eventController.getEventById);
router.get('/getByYear/:year',eventController.getCountedEventsByYear);


module.exports = router;