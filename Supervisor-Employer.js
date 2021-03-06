// Supervisor/ Employer
intent("What (does| can|) (this|alan|) do?", 
       reply("You can assign tasks or create groups with just your voice."));
intent("(Hello|Hi|hey|)", 
      reply("Hello"));

intent("(Join|add|I would like to join|) a group", p => {
    p.play("what is your code?");
    p.then(addGroupCode);
});

// six digit letter + number codes
var groupCodes = "xcx123|123123|345 f f g~marketing|1 2 3 1 2 3~Developer Team| test"; // will likely ignore in the future

var addGroupCode = context(() => {
    intent(`$(T ${groupCodes})`, p => {
        if(p.T.value === "test"){
             p.play(`test complete`);
        }
        p.play(`joined (group|the|) ${p.T.label}`);
        //@ add flutter stuff
    });
});
var groupsList = "software engineers|marketing|all emloyees"  //can be appended in the future
 // assign a task // // (More step possibility)
//
intent("(add|create|append|) (a|a new|) task", p => {
    p.play("to which group would you like to addign the task to?");
    p.then(groupProcess);
    // @add flutter stuff
});

var groupProcess = context(() => {
    intent(`$(T ${groupsList})`, p => {
        p.then(taskProcess)
        // @add flutter stuff
    } );
});
var taskProcess = context(() => {
    intent(` $(TASK* (.*))`, p => {
        //@add flutrer stuff
    });
});
intent(`create task testing`, p => {
    p.play( {command: 'createTask'});
});
// More convenient
// other task route 
intent("(add|create|append|) (a|a new|) task", p => {
    p.play("state group and task");
    p.then(gnTask);
    // @add flutter stuff
});

var gnTask = context(() => {
    intent(`$(T ${groupsList}), $(TASK* (.*))`, p => {
        p.play(`Registered, assigned: ${p.TASK.value} to ${p.T.value}`);
        // @add flutter integration stuff
    });
});

// mark task as complete // in future might make seperate delete task feature
intent(`(Mark|delete task| edit state of |completed task|completed) $(TASK* (.*))`, p => {
    p.play("Task done");
    console.log(`Task: ${p.TASK.value}`);
    // @ add flutter command stuff
});

// read tasks 
intent("(read|what are my| state| list|what do i have to do|) task_", p => {
    // @ communicate with flutter data to list
    p.play(`Your tasks are: `);
});

//read groups
intent("(what are|read|read my| read the|tell me| show| list|list all|) groups", p => {
    p.play(`Here are your groups:`);
    p.play( {command: 'readGroups'});
});
