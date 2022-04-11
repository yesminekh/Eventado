const multer = require('multer');

const MIME_TYPES = {
    'image/jpg': '.jpg',
    'image/jpeg': '.jpg',
    'image/png': '.png'
  };
  var date;
  var newFileName;
  const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'images');
    },
  
    filename: (req, file, clb) => {
        date = +new Date();
        const extension = MIME_TYPES[file.mimetype];
        newFileName = date.toString() + extension;//path.extname(file.originalname);
        clb(null, newFileName);
    }
  });

module.exports = multer({ storage: storage });
