<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Pomodrive Todo</title>
  <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans&display=swap" rel="stylesheet" />
  <style>
    body {
        margin: 0;
        padding: 0;
        min-height: 100vh;
        background: url('images/pink_orange_heart.jpg') no-repeat center center fixed;
        background-size: cover;
        color: #fff;
        font-family: 'Josefin Sans', sans-serif;
        display: flex;
        flex-direction: column;
        font-family: 'Segoe UI Emoji', 'Noto Color Emoji', 'Josefin Sans', sans-serif;
        position: relative;
    }

    /* Optional: Add a subtle overlay to improve text readability */
    body::before {
        content: '';
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.1);
        pointer-events: none;
        z-index: -1;
    }

    .top-bar {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        padding: 25px 30px;
    }

    .brand {
        font-weight: 900;
        line-height: 1.1;
    }

    .brand .title {
        font-size: 2.2em;
        font-weight: 900;
    }

    .brand .author {
        font-size: 0.9em;
        font-weight: 900;
        text-align: right;
    }

    .page-title {
        font-size: 1.8em;
        font-weight: 700;
        text-align: right;
    }

    /* Main Content */
    .main-container {
        flex-grow: 1;
        padding: 0 30px 30px;
        max-width: 1200px;
        margin: 0 auto;
        width: 100%;
        box-sizing: border-box;
    }

    /* Add Todo Form */
    .add-todo-section {
        background: rgba(255, 255, 255, 0.15);
        backdrop-filter: blur(10px);
        border-radius: 1rem;
        padding: 2rem;
        margin-bottom: 2rem;
        border: 1px solid rgba(255, 255, 255, 0.1);
    }

    .form-group {
        margin-bottom: 1rem;
    }

    .form-group label {
        display: block;
        margin-bottom: 0.5rem;
        font-weight: 600;
    }

    .form-group input,
    .form-group textarea,
    .form-group select {
        width: 100%;
        padding: 0.75rem;
        border: 1px solid rgba(255, 255, 255, 0.3);
        border-radius: 8px;
        background: rgba(255, 255, 255, 0.1);
        color: white;
        font-family: inherit;
        box-sizing: border-box;
    }

    .form-group input::placeholder,
    .form-group textarea::placeholder {
        color: rgba(255, 255, 255, 0.7);
    }

    .form-row {
        display: flex;
        gap: 1rem;
        align-items: end;
    }

    .form-row .form-group {
        flex: 1;
    }

    .form-row .form-group:last-child {
        flex: 0 0 auto;
    }

    .btn {
        background: rgba(255, 255, 255, 0.2);
        border: none;
        color: white;
        font-size: 1em;
        padding: 0.75rem 1.5rem;
        border-radius: 8px;
        cursor: pointer;
        transition: 0.3s;
        font-family: inherit;
        font-weight: 600;
    }

    .btn:hover {
        background: rgba(255, 255, 255, 0.3);
        transform: translateY(-1px);
    }

    .btn-small {
        padding: 0.5rem 1rem;
        font-size: 0.9em;
    }

    /* Filters */
    .filters {
        display: flex;
        gap: 1rem;
        margin-bottom: 1.5rem;
        flex-wrap: wrap;
    }

    .filter-btn {
        background: rgba(255, 255, 255, 0.15);
        border: none;
        color: white;
        padding: 0.5rem 1rem;
        border-radius: 6px;
        cursor: pointer;
        transition: 0.3s;
        font-family: inherit;
    }

    .filter-btn:hover,
    .filter-btn.active {
        background: rgba(255, 255, 255, 0.3);
    }

    /* Todo List */
    .todo-list {
        display: flex;
        flex-direction: column;
        gap: 1rem;
    }

    .todo-item {
        background: rgba(255, 255, 255, 0.15);
        backdrop-filter: blur(10px);
        border-radius: 12px;
        padding: 1.5rem;
        border: 1px solid rgba(255, 255, 255, 0.1);
        transition: 0.3s;
    }

    .todo-item:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
    }

    .todo-item.completed {
        opacity: 0.7;
    }

    .todo-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin-bottom: 0.5rem;
    }

    .todo-title {
        font-size: 1.2em;
        font-weight: 600;
        margin: 0;
        flex: 1;
    }

    .todo-title.completed {
        text-decoration: line-through;
        opacity: 0.7;
    }

    .todo-priority {
        padding: 0.25rem 0.5rem;
        border-radius: 4px;
        font-size: 0.8em;
        font-weight: 600;
        margin-left: 1rem;
    }

    .priority-low { background: rgba(52, 211, 153, 0.3); }
    .priority-medium { background: rgba(251, 191, 36, 0.3); }
    .priority-high { background: rgba(239, 68, 68, 0.3); }

    .todo-description {
        margin: 0.5rem 0;
        opacity: 0.9;
        line-height: 1.4;
    }

    .todo-meta {
        font-size: 0.85em;
        opacity: 0.7;
        margin-bottom: 1rem;
    }

    .todo-actions {
        display: flex;
        gap: 0.5rem;
        flex-wrap: wrap;
    }

    .btn-complete {
        background: rgba(52, 211, 153, 0.3);
    }

    .btn-complete:hover {
        background: rgba(52, 211, 153, 0.5);
    }

    .btn-edit {
        background: rgba(59, 130, 246, 0.3);
    }

    .btn-edit:hover {
        background: rgba(59, 130, 246, 0.5);
    }

    .btn-delete {
        background: rgba(239, 68, 68, 0.3);
    }

    .btn-delete:hover {
        background: rgba(239, 68, 68, 0.5);
    }

    /* Bottom Navigation */
    .bottom-nav {
        padding: 20px 30px;
        display: flex;
        justify-content: center;
    }

    .nav-btn {
        background: rgba(255, 255, 255, 0.2);
        border: none;
        color: white;
        padding: 0.75rem 1.5rem;
        border-radius: 8px;
        cursor: pointer;
        transition: 0.3s;
        font-family: inherit;
        font-weight: 600;
        text-decoration: none;
        display: inline-block;
    }

    .nav-btn:hover {
        background: rgba(255, 255, 255, 0.3);
        color: white;
        text-decoration: none;
    }

    /* Empty State */
    .empty-state {
        text-align: center;
        padding: 3rem 2rem;
        opacity: 0.7;
    }

    .empty-state h3 {
        font-size: 1.5em;
        margin-bottom: 0.5rem;
    }

    /* Loading State */
    .loading {
        text-align: center;
        padding: 2rem;
        font-size: 1.1em;
        opacity: 0.8;
    }

    /* Edit Form */
    .edit-form {
        margin-top: 1rem;
        padding: 1rem;
        background: rgba(255, 255, 255, 0.1);
        border-radius: 8px;
    }

    .edit-form .form-group {
        margin-bottom: 0.75rem;
    }

    .edit-form input,
    .edit-form textarea,
    .edit-form select {
        width: 100%;
        padding: 0.5rem;
        border: 1px solid rgba(255, 255, 255, 0.3);
        border-radius: 6px;
        background: rgba(255, 255, 255, 0.15);
        color: white;
        font-family: inherit;
        box-sizing: border-box;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .form-row {
            flex-direction: column;
        }

        .form-row .form-group:last-child {
            flex: 1;
        }

        .todo-header {
            flex-direction: column;
            align-items: flex-start;
        }

        .todo-priority {
            margin-left: 0;
            margin-top: 0.5rem;
        }

        .filters {
            justify-content: center;
        }
    }
  </style>
</head>

<body>
  <!-- Top Bar -->
  <div class="top-bar">
    <div class="brand">
      <div class="title">Pomodrive</div>
      <div class="author">by Ifra</div>
    </div>
    <div class="page-title">📝 Todo Manager</div>
  </div>

  <!-- Main Content -->
  <div class="main-container">
    <!-- Add Todo Form -->
    <div class="add-todo-section">
      <div class="form-row">
        <div class="form-group">
          <label for="todoTitle">Task Title</label>
          <input type="text" id="todoTitle" placeholder="What needs to be done?" maxlength="200" required>
        </div>
        <div class="form-group">
          <label for="todoPriority">Priority</label>
          <select id="todoPriority">
            <option value="1">Low</option>
            <option value="2" selected>Medium</option>
            <option value="3">High</option>
          </select>
        </div>
        <div class="form-group">
          <button type="button" class="btn" onclick="addTodo()">Add Task</button>
        </div>
      </div>
      <div class="form-group">
        <label for="todoDescription">Description (Optional)</label>
        <textarea id="todoDescription" placeholder="Add more details..." rows="2" maxlength="500"></textarea>
      </div>
    </div>

    <!-- Filters -->
    <div class="filters">
      <button class="filter-btn active" data-filter="all">All Tasks</button>
      <button class="filter-btn" data-filter="pending">Pending</button>
      <button class="filter-btn" data-filter="completed">Completed</button>
      <button class="filter-btn" data-filter="high">High Priority</button>
    </div>

    <!-- Todo List -->
    <div id="todoList" class="todo-list">
      <div class="loading">Loading your tasks...</div>
    </div>
  </div>

  <!-- Bottom Navigation -->
  <div class="bottom-nav">
    <a href="<%= request.getContextPath() %>/focus.jsp" class="nav-btn">← Back to Focus Timer</a>
  </div>

  <script>
    // Get context path for API calls
    var contextPath = '<%= request.getContextPath() %>';
    console.log('Context path is:', contextPath);

    let todos = [];
    let currentFilter = 'all';

    // Load saved theme
    document.addEventListener('DOMContentLoaded', function() {
        loadSavedTheme();
        loadTodos();
        setupEventListeners();
    });

    function loadSavedTheme() {
        const savedTheme = sessionStorage.getItem('pomodrive_theme');
        if (savedTheme) {
            document.body.style.backgroundImage = 'url("' + contextPath + '/images/' + savedTheme + '")';
        }
    }

    function setupEventListeners() {
        // Filter buttons
        document.querySelectorAll('.filter-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
                this.classList.add('active');
                currentFilter = this.dataset.filter;
                renderTodos();
            });
        });

        // Enter key to add todo
        document.getElementById('todoTitle').addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                addTodo();
            }
        });
    }

    async function loadTodos() {
        try {
            const response = await fetch(contextPath + '/api/todos');
            if (response.ok) {
                todos = await response.json();
                renderTodos();
            } else if (response.status === 401) {
                window.location.href = contextPath + '/login.jsp';
            } else {
                throw new Error('Failed to load todos');
            }
        } catch (error) {
            console.error('Error loading todos:', error);
            document.getElementById('todoList').innerHTML = 
                '<div class="empty-state"><h3>Failed to load tasks</h3><p>Please refresh the page to try again.</p></div>';
        }
    }

    async function addTodo() {
        const title = document.getElementById('todoTitle').value.trim();
        const description = document.getElementById('todoDescription').value.trim();
        const priority = parseInt(document.getElementById('todoPriority').value);

        if (!title) {
            alert('Please enter a task title');
            return;
        }

        const newTodo = {
            title: title,
            description: description || null,
            priority: priority
        };

        try {
            const response = await fetch(contextPath + '/api/todos', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(newTodo)
            });

            if (response.ok) {
                const createdTodo = await response.json();
                todos.unshift(createdTodo);
                
                // Clear form
                document.getElementById('todoTitle').value = '';
                document.getElementById('todoDescription').value = '';
                document.getElementById('todoPriority').value = '2';
                
                renderTodos();
            } else {
                throw new Error('Failed to create todo');
            }
        } catch (error) {
            console.error('Error creating todo:', error);
            alert('Failed to add task. Please try again.');
        }
    }

    async function toggleTodoComplete(todoId) {
        const todo = todos.find(t => t.id === todoId);
        if (!todo) return;

        const updatedTodo = {
            ...todo,
            completed: !todo.completed
        };

        try {
            const response = await fetch(contextPath + '/api/todos/' + todoId, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(updatedTodo)
            });

            if (response.ok) {
                const index = todos.findIndex(t => t.id === todoId);
                todos[index] = await response.json();
                renderTodos();
            } else {
                throw new Error('Failed to update todo');
            }
        } catch (error) {
            console.error('Error updating todo:', error);
            alert('Failed to update task. Please try again.');
        }
    }

    async function deleteTodo(todoId) {
        if (!confirm('Are you sure you want to delete this task?')) {
            return;
        }

        try {
            const response = await fetch(contextPath + '/api/todos/' + todoId, {
                method: 'DELETE'
            });

            if (response.ok) {
                todos = todos.filter(t => t.id !== todoId);
                renderTodos();
            } else {
                throw new Error('Failed to delete todo');
            }
        } catch (error) {
            console.error('Error deleting todo:', error);
            alert('Failed to delete task. Please try again.');
        }
    }

    function editTodo(todoId) {
        const todo = todos.find(t => t.id === todoId);
        if (!todo) return;

        const todoElement = document.querySelector('[data-todo-id="' + todoId + '"]');
        const actionsDiv = todoElement.querySelector('.todo-actions');
        
        // Create edit form
        const editForm = document.createElement('div');
        editForm.className = 'edit-form';
        editForm.innerHTML = 
            '<div class="form-group">' +
                '<label>Title</label>' +
                '<input type="text" id="edit-title-' + todoId + '" value="' + todo.title.replace(/"/g, '&quot;') + '" maxlength="200">' +
            '</div>' +
            '<div class="form-group">' +
                '<label>Description</label>' +
                '<textarea id="edit-description-' + todoId + '" maxlength="500" rows="2">' + (todo.description || '') + '</textarea>' +
            '</div>' +
            '<div class="form-group">' +
                '<label>Priority</label>' +
                '<select id="edit-priority-' + todoId + '">' +
                    '<option value="1"' + (todo.priority == 1 ? ' selected' : '') + '>Low</option>' +
                    '<option value="2"' + (todo.priority == 2 ? ' selected' : '') + '>Medium</option>' +
                    '<option value="3"' + (todo.priority == 3 ? ' selected' : '') + '>High</option>' +
                '</select>' +
            '</div>' +
            '<div class="todo-actions">' +
                '<button class="btn btn-small btn-complete" onclick="saveEdit(' + todoId + ')">Save</button>' +
                '<button class="btn btn-small btn-delete" onclick="cancelEdit(' + todoId + ')">Cancel</button>' +
            '</div>';

        // Replace actions with edit form
        actionsDiv.style.display = 'none';
        todoElement.appendChild(editForm);
    }

    async function saveEdit(todoId) {
        const title = document.getElementById('edit-title-' + todoId).value.trim();
        const description = document.getElementById('edit-description-' + todoId).value.trim();
        const priority = parseInt(document.getElementById('edit-priority-' + todoId).value);

        if (!title) {
            alert('Please enter a task title');
            return;
        }

        const todo = todos.find(t => t.id === todoId);
        const updatedTodo = {
            ...todo,
            title: title,
            description: description || null,
            priority: priority
        };

        try {
            const response = await fetch(contextPath + '/api/todos/' + todoId, {
                method: 'PUT',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(updatedTodo)
            });

            if (response.ok) {
                const index = todos.findIndex(t => t.id === todoId);
                todos[index] = await response.json();
                renderTodos();
            } else {
                throw new Error('Failed to update todo');
            }
        } catch (error) {
            console.error('Error updating todo:', error);
            alert('Failed to update task. Please try again.');
        }
    }

    function cancelEdit(todoId) {
        renderTodos();
    }

    function renderTodos() {
        const todoList = document.getElementById('todoList');
        let filteredTodos = todos;

        // Apply filter
        switch (currentFilter) {
            case 'pending':
                filteredTodos = todos.filter(t => !t.completed);
                break;
            case 'completed':
                filteredTodos = todos.filter(t => t.completed);
                break;
            case 'high':
                filteredTodos = todos.filter(t => t.priority === 3);
                break;
        }

        if (filteredTodos.length === 0) {
            const emptyMessage = currentFilter === 'all' ? 
                'No tasks yet. Add your first task above!' :
                'No ' + currentFilter + ' tasks found.';
            
            todoList.innerHTML = 
                '<div class="empty-state">' +
                    '<h3>📝 ' + emptyMessage + '</h3>' +
                    '<p>Stay organized and productive!</p>' +
                '</div>';
            return;
        }

        todoList.innerHTML = filteredTodos.map(todo => {
            const priorityText = {1: 'Low', 2: 'Medium', 3: 'High'}[todo.priority];
            const priorityClass = {1: 'priority-low', 2: 'priority-medium', 3: 'priority-high'}[todo.priority];
            
            const createdDate = new Date(todo.createdDate).toLocaleDateString();
            const completedDate = todo.completedDate ? 
                new Date(todo.completedDate).toLocaleDateString() : null;

            return '<div class="todo-item ' + (todo.completed ? 'completed' : '') + '" data-todo-id="' + todo.id + '">' +
                    '<div class="todo-header">' +
                        '<h3 class="todo-title ' + (todo.completed ? 'completed' : '') + '">' + escapeHtml(todo.title) + '</h3>' +
                        '<span class="todo-priority ' + priorityClass + '">' + priorityText + '</span>' +
                    '</div>' +
                    
                    (todo.description ? '<div class="todo-description">' + escapeHtml(todo.description) + '</div>' : '') +
                    
                    '<div class="todo-meta">' +
                        'Created: ' + createdDate +
                        (completedDate ? ' • Completed: ' + completedDate : '') +
                    '</div>' +
                    
                    '<div class="todo-actions">' +
                        '<button class="btn btn-small btn-complete" onclick="toggleTodoComplete(' + todo.id + ')">' +
                            (todo.completed ? '↩️ Reopen' : '✅ Complete') +
                        '</button>' +
                        '<button class="btn btn-small btn-edit" onclick="editTodo(' + todo.id + ')">' +
                            '✏️ Edit' +
                        '</button>' +
                        '<button class="btn btn-small btn-delete" onclick="deleteTodo(' + todo.id + ')">' +
                            '🗑️ Delete' +
                        '</button>' +
                    '</div>' +
                '</div>';
        }).join('');
    }

    function escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    function formatDateTime(dateTimeString) {
        if (!dateTimeString) return '';
        
        const date = new Date(dateTimeString);
        return date.toLocaleDateString() + ' ' + date.toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'});
    }
  </script>
</body>
</html>