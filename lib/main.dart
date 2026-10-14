<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Focus & Flow - رفيق المذاكرة</title>
    <!-- استدعاء خط Cairo الجميل من جوجل -->
    <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-color: #f7f5fc;
            --card-bg: #ffffff;
            --primary-color: #7c3aed;
            --primary-light: #ede9fe;
            --text-main: #1f2937;
            --text-muted: #6b7280;
            --accent-pink: #f472b6;
            --border-color: #e5e7eb;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Cairo', sans-serif;
        }

        body {
            background-color: var(--bg-color);
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .container {
            width: 100%;
            max-width: 480px;
            background: var(--card-bg);
            padding: 30px;
            border-radius: 24px;
            box-shadow: 0 10px 30px rgba(124, 58, 237, 0.08);
            border: 1px solid rgba(237, 233, 254, 0.6);
        }

        /* الهيدر */
        .header {
            text-align: center;
            margin-bottom: 25px;
        }

        .header h1 {
            font-size: 24px;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 5px;
        }

        .header p {
            font-size: 14px;
            color: var(--text-muted);
        }

        /* عداد الوقت (Pomodoro) */
        .timer-box {
            background: var(--primary-light);
            border-radius: 20px;
            padding: 25px;
            text-align: center;
            margin-bottom: 25px;
        }

        .timer-display {
            font-size: 48px;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 15px;
        }

        .timer-btns button {
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 12px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.2s;
            margin: 0 5px;
        }

        .timer-btns button:hover {
            opacity: 0.9;
            transform: translateY(-2px);
        }

        /* قسم مهام اليوم */
        .section-title {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 12px;
            color: var(--text-main);
        }

        .todo-input-group {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
        }

        .todo-input-group input {
            flex: 1;
            padding: 12px 15px;
            border: 1px solid var(--border-color);
            border-radius: 14px;
            outline: none;
            font-size: 14px;
            transition: 0.2s;
        }

        .todo-input-group input:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px var(--primary-light);
        }

        .todo-input-group button {
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 0 20px;
            border-radius: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.2s;
        }

        /* قائمة المهام */
        .todo-list {
            list-style: none;
            max-height: 200px;
            overflow-y: auto;
        }

        .todo-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: var(--bg-color);
            padding: 12px 15px;
            border-radius: 12px;
            margin-bottom: 8px;
            font-size: 14px;
            animation: fadeIn 0.3s ease;
        }

        .todo-item.completed span {
            text-decoration: line-through;
            color: var(--text-muted);
        }

        .todo-actions {
            display: flex;
            gap: 8px;
        }

        .todo-actions button {
            background: none;
            border: none;
            cursor: pointer;
            font-size: 14px;
        }

        .btn-check { color: #10b981; }
        .btn-delete { color: #ef4444; }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(5px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

    <div class="container">
        <!-- الهيدر -->
        <div class="header">
            <h1>✨ Focus & Flow</h1>
            <p>نظّم وقتك، وحافظ على تركيزك بكل إبداع</p>
        </div>

        <!-- مؤقت المذاكرة -->
        <div class="timer-box">
            <div class="timer-display" id="timer">25:00</div>
            <div class="timer-btns">
                <button onclick="startTimer()">ابدأ التركيز</button>
                <button onclick="resetTimer()" style="background: #e5e7eb; color: var(--text-main);">إعادة ضبط</button>
            </div>
        </div>

        <!-- قائمة المهام -->
        <div class="todo-section">
            <div class="section-title">مهام المذاكرة اليومية 🎯</div>
            <div class="todo-input-group">
                <input type="text" id="taskInput" placeholder="أضف مهمة جديدة (مثلاً: حل واجب الفيزياء)...">
                <button onclick="addTask()">إضافة</button>
            </div>
            <ul class="todo-list" id="taskList">
                <!-- المهام هتظهر هنا ديناميكياً -->
            </ul>
        </div>
    </div>

    <script>
        // سكربت بسيط للمؤقت وإضافة المهام
        let timeLeft = 1500; // 25 دقيقة
        let timerId = null;
        let isRunning = false;

        function updateTimerDisplay() {
            let minutes = Math.floor(timeLeft / 60);
            let seconds = timeLeft % 60;
            document.getElementById('timer').innerText = 
                `${minutes < 10 ? '0' : ''}${minutes}:${seconds < 10 ? '0' : ''}${seconds}`;
        }

        function startTimer() {
            if (isRunning) return;
            isRunning = true;
            timerId = setInterval(() => {
                if (timeLeft > 0) {
                    timeLeft--;
                    updateTimerDisplay();
                } else {
                    clearInterval(timerId);
                    isRunning = false;
                    alert('انتهت جلسة التركيز! خذ استراحة قصيرة ☕');
                }
            }, 1000);
        }

        function resetTimer() {
            clearInterval(timerId);
            isRunning = false;
            timeLeft = 1500;
            updateTimerDisplay();
        }

        function addTask() {
            let input = document.getElementById('taskInput');
            let taskText = input.value.trim();
            if (taskText === '') return;

            let list = document.getElementById('taskList');
            let li = document.createElement('li');
            li.className = 'todo-item';
            li.innerHTML = `
                <span>${taskText}</span>
                <div class="todo-actions">
                    <button class="btn-check" onclick="toggleTask(this)">✔️</button>
                    <button class="btn-delete" onclick="deleteTask(this)">🗑️</button>
                </div>
            `;
            list.appendChild(li);
            input.value = '';
        }

        function toggleTask(btn) {
            let item = btn.closest('.todo-item');
            item.classList.toggle('completed');
        }

        function deleteTask(btn) {
            let item = btn.closest('.todo-item');
            item.remove();
        }
    </script>
</body>
</html>
