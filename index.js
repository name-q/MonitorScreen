
const screenshot = require('screenshot-desktop');
const fs = require('fs');
const path = require('path');
const { createCanvas, loadImage } = require('canvas');

const takeScreenshot = () => {
    const filePath = path.join(__dirname, new Date().getTime() + '.jpg');

    screenshot({ format: 'png' }).then((img) => {
        // 使用 canvas 处理图像
        loadImage(img).then((image) => {
            const width = 1000; // 设置新的宽度
            const scaleFactor = width / image.width;
            const height = image.height * scaleFactor;

            const canvas = createCanvas(width, height);
            const ctx = canvas.getContext('2d');
            ctx.drawImage(image, 0, 0, width, height);

            const out = fs.createWriteStream(filePath);
            const stream = canvas.createJPEGStream({
                quality: 1, // 质量设置为 100%
            });
            stream.pipe(out);
            out.on('finish', () => console.log('Screenshot saved as out.jpg'));
        }).catch((err) => {
            console.error('Error processing image:', err);
        });
    }).catch((err) => {
        console.error('Error taking screenshot:', err);
    });
};

setInterval(takeScreenshot, 10 * 1000);


