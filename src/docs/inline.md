I like doing things inline because it does not break focus, break the thought process. I do not want to jump to another file, start to figure out how to name it, how name a function and do the rest of boilerplate. 
I want code to be as close to thought process as possible. 

So i want to make a todo app, I imagine an input with a task and a button and a task list.  
Keep in mind that i have pure js no reactive 


I've developed weird preferences:
i do not like to find name for variables, i do not like to switch focus by jumping 



```lisp
(div 
  (input (placeholder: "taskname"))
  (button "add"))
 
```
now i click a button to add new task 
```lisp
(= tasks (Array))
(div 
  (input (placeholder: "taskname"))
  (button 
    (onClick: (fn 
                (tasks.push 
                 (: text (document.querySelector "input").value 
                    status "new")) ))
    "add"))
 
```

I'd like onClick to look like this

```lisp
(= tasks (Array))
(div 
  (= taskInput (input (: placeholder "task")))
  (on (button "add") "click"
    (tasks.push 
      (: text taskInput.value 
         status "new"))
    (= taskInput.value ""))
         
  (h2 "Tasks")
  (reactive tasks
    (tasks.map
      (fn task
        (div task.text)))))
```