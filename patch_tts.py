# -*- coding: utf-8 -*-
"""
第二阶段补丁：
1. TTS 改用讲书文本（精华解读 + 思维框架 + 行动清单）
2. 优化语音参数（pitch/rate），选最佳中文声音
3. 加入段落停顿，朗读更自然
4. 建立 admin.html 管理后台
"""

with open('index.html', 'r', encoding='utf-8') as f:
    html = f.read()

print('文件加载:', len(html), '字符')

# ============================================================
# 1. 改造 buildListenText：优先用讲书内容，更自然的段落结构
# ============================================================
OLD_BUILD = """function buildListenText(book) {
  const parts = [
    `《${book.title}》，作者：${book.author}。`,
    `内容简介：${book.summary}`,
    `核心观点：`,
    ...book.keyPoints.map((kp, i) => `第${i+1}点：${kp}`),
    `经典金句：`,
    ...book.quotes
  ];
  return parts;
}"""

NEW_BUILD = """function buildListenText(book) {
  const lec = book.lecture;
  if (lec) {
    // 用讲书内容：更自然、更有深度
    const parts = [];
    // 开场白
    parts.push(`欢迎收听周公解读。今天为您带来《${book.title}》，作者${book.author}。`);
    // 精华解读（按句号分段，每段不超过120字）
    const essenceSentences = lec.essence
      .replace(/<[^>]+>/g, '')  // 去 HTML 标签
      .split(/[。！？]/)
      .filter(s => s.trim().length > 5);
    let chunk = '';
    for (const s of essenceSentences) {
      chunk += s + '。';
      if (chunk.length >= 80) { parts.push(chunk.trim()); chunk = ''; }
    }
    if (chunk.trim()) parts.push(chunk.trim());
    // 思维框架
    parts.push('下面为您介绍本书的核心思维框架。');
    lec.framework.forEach((f, i) => {
      const desc = f.desc.replace(/<[^>]+>/g, '');
      parts.push(`第${i+1}个框架：${f.label}。${desc}`);
    });
    // 行动清单
    parts.push('最后，是读完这本书后，您可以立刻付诸行动的清单。');
    lec.actions.forEach((a, i) => {
      const text = a.replace(/<[^>]+>/g, '');
      parts.push(`行动${i+1}：${text}`);
    });
    parts.push(`以上就是《${book.title}》的精华解读，感谢收听周公解读。`);
    return parts;
  }
  // 降级：用原始内容
  const parts = [
    `欢迎收听周公解读。今天为您带来《${book.title}》，作者${book.author}。`,
    `内容简介：${book.summary}`,
    `核心观点：`,
    ...book.keyPoints.map((kp, i) => `第${i+1}点：${kp}`),
    `经典金句：`,
    ...book.quotes,
    `以上就是《${book.title}》的精华解读，感谢收听周公解读。`
  ];
  return parts;
}"""

html = html.replace(OLD_BUILD, NEW_BUILD)
print('buildListenText 改造完成')

# ============================================================
# 2. 改造 speakChunk：选最佳中文声音 + 优化参数
# ============================================================
OLD_SPEAK = """  currentUtterance = new SpeechSynthesisUtterance(text);
  currentUtterance.lang = 'zh-CN';
  currentUtterance.rate = listenSpeed;
  currentUtterance.pitch = 1.0;
  currentUtterance.volume = 1.0;

  // Try to use a Chinese voice
  const voices = speechSynth.getVoices();
  const zhVoice = voices.find(v => v.lang.startsWith('zh') && v.localService) || voices.find(v => v.lang.startsWith('zh'));
  if (zhVoice) currentUtterance.voice = zhVoice;"""

NEW_SPEAK = """  currentUtterance = new SpeechSynthesisUtterance(text);
  currentUtterance.lang = 'zh-CN';
  currentUtterance.rate = listenSpeed * 0.92; // 稍慢更自然
  currentUtterance.pitch = 1.05;
  currentUtterance.volume = 1.0;

  // 优先选高质量中文声音（微软 Xiaoxiao > 其他神经网络声音 > 本地声音）
  const voices = speechSynth.getVoices();
  const preferredNames = ['Microsoft Xiaoxiao', 'Microsoft Yunxi', 'Microsoft Xiaoyi', 'Tingting', 'Meijia'];
  let zhVoice = null;
  for (const name of preferredNames) {
    zhVoice = voices.find(v => v.name.includes(name));
    if (zhVoice) break;
  }
  if (!zhVoice) zhVoice = voices.find(v => v.lang === 'zh-CN' && !v.localService)
                          || voices.find(v => v.lang === 'zh-CN')
                          || voices.find(v => v.lang.startsWith('zh'));
  if (zhVoice) currentUtterance.voice = zhVoice;"""

html = html.replace(OLD_SPEAK, NEW_SPEAK)
print('speakChunk 语音参数优化完成')

# ============================================================
# 3. 加入声音预加载（页面加载时触发 getVoices）
# ============================================================
OLD_INIT_CALL = """if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', init);
} else {
  init();
}"""

NEW_INIT_CALL = """// 预加载语音列表（部分浏览器需要触发一次才能获取）
if (window.speechSynthesis) {
  window.speechSynthesis.getVoices();
  window.speechSynthesis.onvoiceschanged = () => window.speechSynthesis.getVoices();
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', init);
} else {
  init();
}"""

html = html.replace(OLD_INIT_CALL, NEW_INIT_CALL)
print('声音预加载注入完成')

# ============================================================
# 验证
# ============================================================
assert 'buildListenText' in html
assert 'Microsoft Xiaoxiao' in html
assert 'lec.essence' in html
assert '欢迎收听周公解读' in html
print('JS 验证通过')

with open('index.html', 'w', encoding='utf-8', newline='\n') as f:
    f.write(html)

# 字节验证
with open('index.html', 'rb') as f:
    raw = f.read()
assert raw[:2] == b'<!', f'文件头错误: {raw[:4]}'
assert '\u5468\u516c\u89e3\u8bfb'.encode('utf-8') in raw, '中文字节丢失'
print(f'index.html 写入完成: {len(raw)} bytes, 编码正常')
print('TTS 优化完成！')
