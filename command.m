function c=command(current_state, next_state)
V_a=0.0248*2;
%angular velocity
V_t=0.20;
%translation velocity
t_a=0;
%spin time
t_T=0;
%go time
changeX=-(current_state(4,1)-next_state(4,1));
changeY=-(current_state(5,1)-next_state(5,1));
%changeA=current_state(6,1)-next_state(6,1);
if(changeX>0.5 && changeY>0.5)
    changeA=pi/4-current_state(6,1);
    t_a=changeA/V_a;
    %spin time
    t_T=sqrt(2)/V_t;
end
if(changeX>0.5 && abs(changeY)<0.25)
    changeA=0-current_state(6,1);
    t_a=changeA/V_a;
    %spin time
    t_T=1/V_t;
end
if(changeX>0.5 && changeY<-0.5)
    changeA=-pi/4-current_state(6,1);
    t_a=changeA/V_a;
    %spin time
    t_T=sqrt(2)/V_t;
end
if(abs(changeX)<0.25 && changeY<-0.5)
    changeA=-pi/2-current_state(6,1);
    t_a=changeA/V_a;
    %spin time
    t_T=1/V_t;
end
if(changeX<-0.5 && changeY<-0.5)
    changeA=-pi*0.75-current_state(6,1);
    t_a=changeA/V_a;
    %spin time
    t_T=sqrt(2)/V_t;
end
if(changeX<-0.5 && abs(changeY)<0.25)
    changeA=-pi-current_state(6,1);
    t_a=changeA/V_a;
    %spin time
    t_T=1/V_t;
end
if(changeX<-0.5 && changeY>0.5)
    changeA=pi*0.75-current_state(6,1);
    t_a=changeA/V_a;
    %spin time
    t_T=sqrt(2)/V_t;
end
if(abs(changeX)<0.25 && changeY>0.5)
    changeA=pi/2-current_state(6,1);
    t_a=changeA/V_a;
    %spin time
    t_T=1/V_t;
end
%1-turn left, 0 turn right
%1-go forward, 0 go backward
if(changeA>0)
    turn=1;
else
    turn=0;
end
c=[turn;t_a;1;t_T];
end
    