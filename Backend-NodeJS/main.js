const express = require('express')
const http = require('http')
const multer = require('multer');
const path = require("path");
const { exec } = require('child_process');
const app = express()
const server = http.createServer(app)
const PORT = 5000

app.use(express.json());
app.use(express.urlencoded({ extended: false}));

require('dotenv').config();
const { OpenAI } = require('openai');

const OPENAI_API_KEY = process.env.OPENAI_API_KEY;
const openai = new OpenAI({
  apiKey: OPENAI_API_KEY
});

var mysql = require('mysql');
var connection = mysql. createConnection({
    host    : 'localhost',
    user    : 'nodejs',
    password    : 'myssu',
    database    : 'mymedicine'
});

connection.connect();

app.get('/ping', (req, res) => { //end
    res.writeHead(204);
    res.write(``)
    res.end()
});

app.get('/login', (req, res) => { //end
    const {loginId, password} = req.query;
    console.log(req.query);
    connection.query(`SELECT loginId,password FROM users WHERE loginId="${loginId}"`, function(error, results, fields){
        if (error) {
            res.status(401).send({ message: 'wrong loginId' });
        }
        else {
            console.log();
            if(results.length==0) {
                res.status(401).send({ message: 'wrong loginId' });
            }
            else {
                if(results[0].password==password) {
                    connection.query(`SELECT uid FROM users WHERE loginId="${loginId}"`, function(error, results, fields){
                        if (error) { console.log(error); }
                        console.log(results);
                        let sendPkt=results[0].uid
                        res.status(200).send({ uid: sendPkt });
                    });
                }
                else res.status(401).send({ message: 'wrong password' });
            }
        }
    });
});

app.get('/getUserInfo', (req, res) => { //end
    const {uid} = req.query;
    connection.query(`SELECT uid,name,allergic FROM users WHERE uid=${uid}`, function(error, results, fields){
        if (error) { console.log(error); }
        console.log(results);
        res.status(200).send(results);
    });
});

app.get('/getPrescList', (req, res) => { //end
    const {uid} = req.query;
    connection.query(`SELECT prescIdList FROM users WHERE uid=${uid}`, function(error, results, fields){
        if (error) { console.log(error); }
        if (results.length > 0) {
            const tempPrescIds = results[0].prescIdList.split(',').map(prescId => parseInt(prescId));
            const newData = { prescIdList: tempPrescIds };
            console.log(newData);
            res.status(200).send(newData);
        } else {
            console.log('No data found');
            res.status(404).send({ message: 'No data found' });
        }
    });
});

app.get('/getPrescPic', (req, res) => { //end
    const {prescId} = req.query;
    var fs = require('fs'); 
    var file;
    try {
        file = fs.readFileSync(`../image/${prescId}.jpg`)
    }
    catch (err) {
        file = fs.readFileSync(`../image/0000.jpg`)
    }
    res.writeHead(200, {"Content-Type":"image/jpg"})
    res.write(file)
    res.end()
});

app.get('/getPrescInfo', (req, res) => { //end
    const {prescId} = req.query;
    connection.query(`SELECT * FROM prescriptions WHERE prescId=${prescId}`, function(error, results, fields){
        if (error) { console.log(error); }
        console.log(results);
        res.status(200).send(results);
    });
});

app.get('/presc', (req, res) => { //end
    const {prescId} = req.query;
    connection.query(`SELECT medicine FROM prescriptions WHERE prescId=${prescId}`, function(error, results, fields){
        if (error) { console.log(error); }
        console.log(results[0].medicine);

        async function main() {
            const completion = await openai.chat.completions.create({
              messages: [{"role": "system", "content": "너는 약 복용 주의사항을 알려주는 비서야. 약 리스트를 넘겨주면, 해당 약별로 복용 주의사항을 응답해줘. 앞에 '알겠습니다.'는 붙이지 마. 형식은 약명:\n-주의사항 1\n-주의사항2.. 이렇게 해줘."},
                  {"role": "user", "content": `"${results[0].medicine}"`}],
              model: "gpt-3.5-turbo",
            });
            generatedInstruction = completion.choices[0].message.content;
            console.log(generatedInstruction);
          
            connection.query(`UPDATE prescriptions SET generatedInstruction="${generatedInstruction}" WHERE prescId=${prescId}`, function(error, results, fields){
                if (error) { console.log(error); }
                console.log(results);
            });
        }
        main();

        res.status(200).send(results[0].medicine);
    });
});

app.get('/newUser', (req, res) => { //end
    const { uid, loginId, password, name, allergic } = req.query;
    connection.query(`INSERT INTO users VALUES(${uid}, ${loginId}, ${password}, ${name}, "", ${allergic})`, function(error, results, fields){
        if (error) { console.log(error); }
        console.log(results);
        res.writeHead(204);
        res.write(``)
        res.end()
    });
});

app.delete('/delPresc', (req, res) => {
    const {uid} = req.query;
    const {prescId} = req.query;

    const fs = require('fs');
    fs.unlink(`/mymedicine/image/${prescId}.jpg`, err => {});

    connection.query(`DELETE from prescriptions where prescId=${prescId}`, function(error, results, fields){
        if (error) { console.log(error); }
        console.log(results);
    });
    connection.query(`select prescIdList from users where uid=${uid}`, function(error, results, fields){
        let prescIdList;
        for (let i = 0; i < results.length; i++) {
            for (let keyNm in results[i]) {
                if (keyNm === "prescIdList") {
                    prescIdList = results[i][keyNm];
                }
            }
        }
        let arr = prescIdList.split(",");
        let newArr = arr.filter(item => item !== `${prescId}`);
        let newprescIdList = newArr.join(",");
        console.log(newprescIdList);

        connection.query(`UPDATE users SET prescIdList="${newprescIdList}" WHERE uid=${uid};`, function(error, results, fields){
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
        cb(null, file.originalname);//파일이름 prescId.jpg로 저장기능 구현
    },
});

const upload = multer({ storage });

app.post('/newPresc', upload.single('image'), async (req, res) => {
    const { uid, medList, duration } = req.body;
    console.log(`uid:${uid}, list:${medList}`);

    try {
        const results = await new Promise((resolve, reject) => {
            connection.query(`SELECT uid,name,prescIdList,allergic FROM users WHERE uid=${uid}`, function(error, results, fields){
                if (error) {
                    reject(error);
                } else {
                    resolve(results);
                }
            });
        });

        let prescIdList;
        for (let i = 0; i < results.length; i++) {
            for (let keyNm in results[i]) {
                if (keyNm === "prescIdList") {
                    prescIdList = results[i][keyNm];
                }
            }
        }
        console.log(prescIdList);
        let count
        if(prescIdList!="") { 
            let prescIdListLength = prescIdList.split(',').length; 
            var arr = prescIdList.split(',');
            let last = arr[prescIdListLength-1].slice(-3);
            console.log(`last prescId : ${last}`);
            count = parseInt(last);
        }
        else count = 0;
        console.log(count);
        const prescId = parseInt(uid) + count + 1;

        if(prescIdList!="") {
            prescIdList += ',';
            prescIdList += String(prescId);
        }
        else prescIdList = String(prescId);

        console.log(prescIdList);
        
        const results2 = await new Promise((resolve, reject) => {
            connection.query(`UPDATE users SET prescIdList="${prescIdList}" WHERE uid=${uid}`, function(error, results, fields){
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
            connection.query(`INSERT INTO prescriptions VALUES(${prescId},"${formattedDate}",${duration} ,"${medList}", "")`, function(error, results, fields){
                if (error) {
                    reject(error);
                } else {
                    resolve(results);
                }
            });
        });
        res.status(200).send(`[{"res":` + String(prescId) + `}]`);

        const newFileName = `${prescId}.jpg`; // 새 파일 이름 설정

        var fs = require('fs');
        fs.rename(req.file.path, path.join("/mymedicine/image", newFileName), async (err) => {
        });
        exec(`python3 cv.py ${prescId}`, (error, stdout, stderr) => {
            if (error) {
              console.error(`이미지 처리 오류 발생`);
            }
            console.log(`이미지 처리 완료`);
          });
          
        async function main() {
            const completion = await openai.chat.completions.create({
              messages: [{"role": "system", "content": "너는 약 복용 주의사항을 알려주는 비서야. 약 리스트를 넘겨주면, 해당 약별로 복용 주의사항을 응답해줘. 앞에 '알겠습니다.'는 붙이지 마. 형식은 약명:\n-주의사항 1\n-주의사항2.. 이렇게 해줘."},
                  {"role": "user", "content": `"${medList}"`}],
              model: "gpt-3.5-turbo",
            });
            generatedInstruction = completion.choices[0].message.content;
            console.log(generatedInstruction);
    
            connection.query(`UPDATE prescriptions SET generatedInstruction="${generatedInstruction}" WHERE prescId=${prescId}`, function(error, results, fields){
                if (error) { console.log(error); }
                console.log(results);
            });
        }
        main();
    } catch (error) {
        console.error(error);
        res.status(500).send(``);
    }
});

server.listen(PORT, () => {
    console.log(`Server running on ${PORT}`);
});
