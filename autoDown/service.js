import express from 'express'
import { exec } from "child_process";

const app = express()

app.listen(51234,()=>{
    console.log("autoDown Online")
})

app.get('/shutdown',(req,res)=>{

    setTimeout(()=>{
        exec("systemctl poweroff", (error) => {
        if (error) {
            console.log(error);
        }
    });
    },3000)

    res.send("Shutting down in 3 seconds")
})