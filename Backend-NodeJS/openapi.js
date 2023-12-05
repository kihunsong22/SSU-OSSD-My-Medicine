require('dotenv').config();
const { OpenAI } = require('openai');

const OPENAI_API_KEY = process.env.OPENAI_API_KEY;
const openai = new OpenAI({
  apiKey: OPENAI_API_KEY
});

async function main() {
  const completion = await openai.chat.completions.create({
    messages: [{"role": "system", "content": "너는 약 복용 주의사항을 알려주는 비서야. 약 리스트를 넘겨주면, 해당 약별로 복용 주의사항을 응답해줘. 앞에 '알겠습니다.'는 붙이지 마. 형식은 약명:\n-주의사항 1\n-주의사항2.. 이렇게 해줘."},
        {"role": "user", "content": "오구멘틴,록소프로펜정,씨잘정"}],
    model: "gpt-3.5-turbo",
  });
  generatedInstruction = completion.choices[0].message.content;
  console.log(generatedInstruction);

  connection.query(`UPDATE prescriptions SET generatedInstruction="${generatedInstruction}" WHERE prescId=2002`, function(error, results, fields){
      if (error) { console.log(error); }
      console.log(results);
  });
}
main();