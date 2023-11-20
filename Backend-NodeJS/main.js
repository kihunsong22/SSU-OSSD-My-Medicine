const express = require('express')
const http = require('http')
const multer = require('multer');
const path = require("path");
const app = express()
const server = http.createServer(app)
const PORT = 5000

app.use(express.json());
app.use(express.urlencoded({ extended: false}));


var mysql = require('mysql'); // mysql 변수에 mysql 모듈을 할당
var connection = mysql. createConnection({  //커넥션변수에 mysql변수에 있는 크리에이드커넥션 메소드를 호출(객체를 받음) 할당
    host    : 'localhost',   //host객체 - 마리아DB가 존재하는 서버의 주소
    user    : 'nodejs', //user객체 - 마리아DB의 계정
    password    : 'myssu',   //password객체 - 마리아DB 계정의 비밀번호
    database    : 'mymedicine'   //database객체 - 접속 후 사용할 DB명
});

connection.connect();

app.get('/', (req, res) => {
    res.send(`alive`)
});

app.get('/getList', (req, res) => { //end
    const {uid} = req.query;
    connection.query(`SELECT * FROM users WHERE uid=${uid}`, function(error, results, fields){
        if (error) { console.log(error); }
        console.log(results);
        res.send(results);
    });
});

app.get('/getMedPic', (req, res) => { //end
    const {id} = req.query;
    var fs = require('fs');
    const file = fs.readFileSync(`../image/${id}.jpg`)
    res.writeHead(200, {"Content-Type":"image/jpg"})
    res.write(file)
    res.end()
});

app.get('/getMedList', (req, res) => { //end
    const {id} = req.query;
    connection.query(`SELECT * FROM medicine WHERE id=${id}`, function(error, results, fields){
        if (error) { console.log(error); }
        console.log(results);
        res.send(results);
    });
});


app.get('/newUser', (req, res) => { //end
    const { uid, allergic } = req.query;
    connection.query(`INSERT INTO users VALUES(${uid}, NULL ,${allergic})`, function(error, results, fields){
        if (error) { console.log(error); }
        console.log(results);
        res.send("ok");
    });
});

const storage = multer.diskStorage({
    destination(req, file, cb) {
        cb(null, path.join("/mymedicine", "image"));
    },
    filename(req, file, cb) {
        cb(null, file.originalname);//파일이름 등록건id.jpg로 저장기능 구현
    },
});

const upload = multer({ storage });

app.post('/enroll', upload.single('image'), async (req, res) => {
    const { uid, medList } = req.body;
    console.log(`uid:${uid}, list:${medList}`);

    try {
        const results = await new Promise((resolve, reject) => {
            connection.query(`SELECT * FROM users WHERE uid=${uid}`, function(error, results, fields){
                if (error) {
                    reject(error);
                } else {
                    resolve(results);
                }
            });
        });

        let regid;
        for (let i = 0; i < results.length; i++) {
            for (let keyNm in results[i]) {
                if (keyNm === "regid") {
                    regid = results[i][keyNm];
                }
            }
        }
        console.log(regid);
        let count
        if(regid!=null) { count = regid.split(',').length; }
        else count = 0;
        console.log(count);
        const id = parseInt(uid) + count + 1;

        if(regid!=null) {
            regid += ',';
            regid += String(id);
        }
        else regid = String(id);

        console.log(regid);
        
        const results2 = await new Promise((resolve, reject) => {
            connection.query(`UPDATE users SET regid="${regid}" WHERE uid=${uid}`, function(error, results, fields){
                if (error) {
                    reject(error);
                } else {
                    resolve(results);
                }
            });
        });
        const results3 = await new Promise((resolve, reject) => {
            connection.query(`INSERT INTO medicine VALUES(${id}, "${medList}")`, function(error, results, fields){
                if (error) {
                    reject(error);
                } else {
                    resolve(results);
                }
            });
        });
        
        res.status(200).send(String(id));

        const newFileName = `${id}.jpg`; // 새 파일 이름 설정

        var fs = require('fs');
        fs.rename(req.file.path, path.join("/mymedicine/image", newFileName), async (err) => {
        });
    } catch (error) {
        console.error(error);
        res.status(500).send('Error');
    }
});


server.listen(PORT, () => {
    console.log(`Server running on ${PORT}`);
});