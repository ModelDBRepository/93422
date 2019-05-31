function y = mv(t,y,rates)

%% Calculation of movement onset

om = (max(y(:,8)) - y(1:1,8)) * 0.1 + y(1:1,8);  % 10% of Vmax (sample 1)
ss = ((max(y(:,8))-y(1:1,8))*0.1 - (max(y(:,8))-y(1:1,8))*0.01) + y(1:1,8); % sample s
m = 0;
count1 = 1;

for k=1:length(y(:,8))
   if (y(k,8) >= ss & y(k,8) <= om)  
       m = m + 1;
       yyyy(m,1) = y(k,8);
       SD = std(yyyy); % Calculation of the standard deviation between sample 1 and sample s
       count1 = 2;   
   end
end   
   
for k=1:length(y(:,8))
	if (count1 == 2)
		if (y(k,8) >= (ss-SD))
         tom = t(k,1);    % Locate first sample <= (sample s - SD); Movement Onset
         uom = rates(k,10); % Locate onset of DVV1 activity
         EMGom = y(k,11);   % Locate onset of EMG activity
   		count1 = 3;
		end
	end
end

%y = tom;

%% Calculation of movement end
 
len = length(y(:,8));
s1end = (max(y(:,8))-y(len,8))*0.1+y(len,8);  % 10% of Vmax (sample 1)
ssend = ((max(y(:,8))-y(len,8))*0.1 - (max(y(:,8))-y(len,8))*0.01) + y(len,8); % sample s
ml = 0;
count = 1;

for k = 1:length(y(:,8))
	if (count == 1)
		if (y(k,8) == max(y(:,8)))
   		    tvmax = t(k,1)
   		    count = 2;
		end
	end
end   

for k=1:length(y(:,8))
	if (count == 2)
		if (t(k,1) > tvmax)
   		    if (y(k,8) >= ssend & y(k,8) <= s1end) % Decrease the AbsTol if it doesn't go through this line
      		    ml = ml + 1;
      		    yyyyy(ml,1) = y(k,8);
         	    SD1 = std(yyyyy);
                tSD1 = t(k,1);
                count = 3;
   		    end
   	    end
	end
end

for k=1:length(y(:,8))
  if (t(k,1) > tvmax)
   	  if (count == 3)
         if (y(k,8) <= (ssend)) 
         	tem = t(k,1)
			count = 4;
      	 end
   	 end
  end
end

cout1 = 1;
cout2 = 1;
cout3 = 1;
for k=1:length(y(:,8))
   if (cout1 == 1)
	   if ((rates(k,10)-rates(1:1,10)) > 0.00001)
   	   ttt = t(k,1);        % Cellular reaction time (CRT) ends
      	cout1 = 2;
   	end
   end
   if (t(k,1) > tvmax)
      if (cout3 == 1)
      	if ((rates(k,10)-rates(len,10)) <= 0.02)
   	   	tttt = t(k,1);        % TB + TA + CRT ends
      		cout3 = 2;
         end
      end      
   end
   if (cout2 == 1)
	   if ((abs(y(k,11))-abs(y(1:1,11))) > 0.0001)
   	   ttttt = t(k,1);        % Premotor reaction time (PMT) ends
      	cout2 = 2;
   	end
   end
end

%% Neuronal variables
PeakNeuronalActivity = max(rates(:,10))
CellularReactionTime = ttt
TA = tom - ttt
TB = tttt - tom

%% Muscular variables
EMGmax = max(y(:,11))
PremotorReactionTime = ttttt
ElectroMechanicalDelayTime = tom - ttttt

%% Kinematic variables
PeakVelocity = max(y(:,8))
MovementOnset = tom
MovementEnd = tem
%MovementEnd = tttt
MovementDuration = MovementEnd - MovementOnset
TimeToPeakVelocity = tvmax - tom
DecelerationTime = tem - tvmax
MovementTime = TimeToPeakVelocity + DecelerationTime
BehavioralReactionTime = CellularReactionTime + TA
% ReactionTime = PremotorReactionTime + ElectroMechanicalDelayTime;
Force = max(rates(:,4))

% % if dopamine depleted case use the following definitions, else use the
% % above ones
% MT = TB;
% TB = MovementDuration;
% 
y = [MovementOnset CellularReactionTime tttt MovementEnd];