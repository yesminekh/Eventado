const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const multer = require('../middleware/multer-config');



router.get("/", userController.getAllUsers);

router.get('/getByEmail',userController.getByEmail);


router.post('/', multer.single('Avatar'),userController.createUser);
router.get('/:id',userController.getById);



router.post('/login',userController.login);

router.put('/:id',userController.updateUser);

router.get("/confirmation/:token", userController.confirmation);

router.post("/resendConfirmation", userController.resendConfirmation);

router.post("/forgotPassword", userController.forgotPassword);

router.patch("/editPassword", userController.resetPassword);



router.put('/:id/follow',userController.makeFollow);

router.get('/followers/:id',userController.getFollowers)

router.get('/following/:id',userController.getFollowing)


module.exports = router;