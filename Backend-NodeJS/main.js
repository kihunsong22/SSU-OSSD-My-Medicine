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

app.get('/ping', (req, res) => { //end
    res.writeHead(204);
    res.write(``)
    res.end()
});

app.get('/getUserInfo', (req, res) => { //end
    const {uid} = req.query;
    connection.query(`SELECT uid,name,allergic FROM users WHERE uid=${uid}`, function(error, results, fields){
        if (error) { console.log(error); }
        console.log(results);
        res.status(200).send(results);
    });
});

app.get('/getPrescList', (req, res) => {
    const {uid} = req.query;
    connection.query(`SELECT prescId FROM users WHERE uid=${uid}`, function(error, results, fields){
        if (error) { console.log(error); }
        if (results.length > 0) {
            const prescIds = results[0].prescId.split(',').map(id => parseInt(id));
            const newData = { prescId: prescIds };
            console.log(newData);
            res.status(200).send(newData);
        } else {
            console.log('No data found');
            res.status(404).send({ message: 'No data found' });
        }
    });
});

app.get('/getPrescPic', (req, res) => { //end
    const {id} = req.query;
    var fs = require('fs');
    const file = fs.readFileSync(`../image/${id}.jpg`)
    res.writeHead(200, {"Content-Type":"image/jpg"})
    res.write(file)
    res.end()
});

app.get('/getPrescInfo', (req, res) => { //end
    const {id} = req.query;
    connection.query(`SELECT * FROM medicine WHERE id=${id}`, function(error, results, fields){
        if (error) { console.log(error); }
        console.log(results);
        res.status(200).send(results);
    });
});

app.get('/newUser', (req, res) => { //end
    const { uid, name, allergic } = req.query;
    connection.query(`INSERT INTO users VALUES(${uid}, ${name}, "",${allergic})`, function(error, results, fields){
        if (error) { console.log(error); }
        console.log(results);
        res.writeHead(204);
        res.write(``)
        res.end()
    });
});

app.delete('/delPresc', (req, res) => {
    const {uid} = req.query;
    const {id} = req.query;

    const fs = require('fs');
    fs.unlink(`/mymedicine/image/${id}.jpg`, err => {});

    connection.query(`DELETE from medicine where id=${id}`, function(error, results, fields){
        if (error) { console.log(error); }
        console.log(results);
    });
    connection.query(`select prescId from users where uid=${uid}`, function(error, results, fields){
        let prescId;
        for (let i = 0; i < results.length; i++) {
            for (let keyNm in results[i]) {
                if (keyNm === "prescId") {
                    prescId = results[i][keyNm];
                }
            }
        }
        let arr = prescId.split(",");
        let newArr = arr.filter(item => item !== `${id}`);
        let newprescId = newArr.join(",");
        console.log(newprescId);

        connection.query(`UPDATE users SET prescId="${newprescId}" WHERE uid=${uid};`, function(error, results, fields){
            console.log(results);
        });
    });
    
    res.writeHead(204)
    res.write(``)
    res.end()
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

app.post('/newPresc', upload.single('image'), async (req, res) => {
    const { uid, medList, duration } = req.body;
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

        let prescId;
        for (let i = 0; i < results.length; i++) {
            for (let keyNm in results[i]) {
                if (keyNm === "prescId") {
                    prescId = results[i][keyNm];
                }
            }
        }
        console.log(prescId);
        let count
        if(prescId!="") { 
            let prescIdLength = prescId.split(',').length; 
            var arr = prescId.split(',');
            let last = arr[prescIdLength-1].charAt(3);
            console.log(`last id : ${last}`);
            count = parseInt(last);
        }
        else count = 0;
        console.log(count);
        const id = parseInt(uid) + count + 1;

        if(prescId!="") {
            prescId += ',';
            prescId += String(id);
        }
        else prescId = String(id);

        console.log(prescId);
        
        const results2 = await new Promise((resolve, reject) => {
            connection.query(`UPDATE users SET prescId="${prescId}" WHERE uid=${uid}`, function(error, results, fields){
                if (error) {
                    reject(error);
                } else {
                    resolve(results);
                }
            });
        });
        
        const currentDate = new Date();
        const formattedDate = `${currentDate.getFullYear()}-${currentDate.getMonth() + 1}-${currentDate.getDate()}`;

        const results3 = await new Promise((resolve, reject) => {
            connection.query(`INSERT INTO medicine VALUES(${id},"${formattedDate}",${duration} ,"${medList}")`, function(error, results, fields){
                if (error) {
                    reject(error);
                } else {
                    resolve(results);
                }
            });
        });
        res.status(200).send(`[{"res":` + String(id) + `}]`);

        const newFileName = `${id}.jpg`; // 새 파일 이름 설정

        var fs = require('fs');
        fs.rename(req.file.path, path.join("/mymedicine/image", newFileName), async (err) => {
        });
    } catch (error) {
        console.error(error);
        res.status(500).send(``);
    }
});

server.listen(PORT, () => {
    console.log(`Server running on ${PORT}`);
});
