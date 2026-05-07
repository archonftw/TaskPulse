import express from 'express'
import { exec } from "child_process";

const app = express()

app.listen(51234,()=>{
    console.log("autoDown Online")
})

app.get('/shutdown',(req,res)=>{

    exec("systemctl poweroff", (error) => {
        if (error) {
            console.log(error);
        }
    });
})