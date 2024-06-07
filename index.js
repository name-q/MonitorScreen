const screenshot = require('screenshot-desktop');
const { createCanvas, loadImage } = require('canvas');
const OSS = require('ali-oss');

// 配置阿里云 OSS
const client = new OSS({
  region: '<Your region>',
  accessKeyId: '<Your accessKeyId>',
  accessKeySecret: '<Your accessKeySecret>',
  bucket: '<Your bucket>'
});

const takeScreenshot = async () => {
  try {
    const img = await screenshot({ format: 'png' });
    const image = await loadImage(img);

    const width = 1000; // 设置新的宽度
    const scaleFactor = width / image.width;
    const height = image.height * scaleFactor;

    const canvas = createCanvas(width, height);
    const ctx = canvas.getContext('2d');
    ctx.drawImage(image, 0, 0, width, height);

    // 转换为 Buffer 100%画质 - 上部分宽度处理->重绘已经算压缩了
    const buffer = canvas.toBuffer('image/jpeg', { quality: 1 });

    // 上传到 OSS
    const objectName = `screenshots/${Date.now()}.jpg`;
    const result = await client.put(objectName, buffer);
    console.log('Screenshot uploaded to OSS:', result.url);
  } catch (err) {
    console.error('Error taking screenshot or uploading:', err);
  }
};

// 每10s截屏一次
setInterval(takeScreenshot, 10 * 1000);
