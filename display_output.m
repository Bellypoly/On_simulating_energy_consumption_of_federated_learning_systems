function display_output(device,keep,M,N,k,type)
%     if(~isempty(device))
%         device1 = device(1);
%         device2 = device(2);
%         device3 = device(3);
%     end
    if(~isempty(keep))
        acc = keep(1:M,1:k); 
        t_loc = keep(1:M,(k+1):(k*2)); 
        e_loc = keep(1:M,(k*2)+1:(k*3)); 
        t_up = keep(1:M,(k*3)+1:(k*4)); 
        e_up = keep(1:M,(k*4)+1:(k*5));
    else
        acc     = [];
        t_loc   = [];   e_loc = [];
        t_up    = [];   e_up = [];
    end
    
    if(type == 11)
        fprintf('\n');
        fprintf('|=====================================================================================================================|\n');
        fprintf('|   Global  |   Local   |                        |                 |                  |                |              |\n');
        fprintf('| Iteration | Iteration |                        |    Machine 1    |    Machine 2     |   Machine 3    |     Total    |\n');
        fprintf('|   ( M )   |   ( N )   |                        |                 |                  |                |              |\n');
        fprintf('|=====================================================================================================================|\n');
        for i = 1:M
%             fprintf('|     %d     |     %d     |   accuracy (%%)          |     %.2f %%     |     %.2f %%      |     %.4f %%    |              |\n', i, N, acc(i,:)*100);
            fprintf('|    %d     |     %d    |   training time (s)    |     %.4f     |     %.4f     |     %.4f    |    %.4f    |\n',i, N,t_loc(i,:), sum(t_loc(i,:)));
            fprintf('|           |           |   traning energy(J)    |     %.2f     |     %.2f     |     %.2f     |    %.2f  |\n',e_loc(i,:), sum(e_loc(i,:)));
            fprintf('|           |           |   commu. time   (s)    |     %.2f     |     %.2f       |     %.2f     |    %.2f   |\n',t_up(i,:)*i, sum(t_up(i,:))*i);
            fprintf('|           |           |   commu. energy (J)    |     %.2f     |     %.2f       |     %.2f     |    %.2f   |\n',e_up(i,:)*i, sum(e_up(i,:))*i);
            fprintf('|           |           |- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |\n');
            fprintf('|           |           |   Total time    (s)    |                                                         %.2f    |\n', total_time_noma(sum(t_loc(i,:)), sum(t_up(i,:)), i, N));
            fprintf('|           |           |   Total energy  (J)    |                                                         %.2f   |\n', sum((sum(e_loc(1:i,:))+sum(e_up(1:i,:)))));
            fprintf('|- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |\n');
        end
        fprintf('|================================================================================================================|\n');
    elseif(type == 12)
        fprintf('\n');
        fprintf('|================================================================================================================|\n');
        fprintf('|   Global  |   Local   |                |                  |         training         |      communication      |\n');
        fprintf('| Iteration | Iteration | Total time (s) | Total energy (J) |------------|-------------|------------|------------|\n');
        fprintf('|   ( M )   |   ( N )   |                |                  |  time (s)  |  energy (J) |  time (s)  | energy (J) |\n');
        fprintf('|================================================================================================================|\n');
        for i = 1:M
            fprintf('|     %d     |     %d     |     %.2f     |      %.2f     |    %.4f   |   %.2f   |   %.4f   |   %.2f   |\n',i, N,...
                total_time_noma(sum(t_loc(i,:)), sum(t_up(i,:)), i, N),sum((sum(e_loc(1:i,:))+sum(e_up(1:i,:)))),...
                sum(sum(t_loc(1:i,:))), sum(sum(e_loc(1:i,:))),...
                sum(sum(t_up(1:i,:))), sum(sum(e_up(1:i,:))));
        end
        fprintf('|=================================================================================================================|\n');
    elseif(type == 13)
        fprintf('\n');
        fprintf('|================================================================================================================|\n');
        fprintf('|   Global  |   Local   |                    |                     |  training per iteration  |   commu. per iteration  |\n');
        fprintf('| Iteration | Iteration |   Total time (s)   |   Total energy (J)  |------------|-------------|------------|------------|\n');
        fprintf('|   ( M )   |   ( N )   | M(N*t_comp+t_comm) |  M(N*e_comp+e_comm) | t_comp (s) |  e_comp (J) | t_comm (s) | e_comm (J) |\n');
        fprintf('|================================================================================================================|\n');
        for i = 1:M
            fprintf('|     %d     |     %d     |     %.2f     |      %.2f     |    %.4f   |   %.2f   |   %.2f   |   %.2f   |\n',i, N,...
                total_time_noma(sum(t_loc(i,:)), sum(t_up(i,:)), i, N),sum((sum(e_loc(1:i,:))+sum(e_up(1:i,:)))),...
                sum(sum(t_loc(i,:))), sum(sum(e_loc(i,:))),...
                sum(sum(t_up(i,:))), sum(sum(e_up(i,:))));
        end
%         fprintf('|- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |\n');
%         fprintf('|                       |    %.2f     |    %.2f                                                      |\n',...
%             total_time_noma(sum(t_loc(i,:)), sum(t_up(i,:)), i, N), sum((sum(e_loc(1:i,:))+sum(e_up(1:i,:)))));
        fprintf('|=================================================================================================================|\n');
    elseif(type == 2)
        % M vs Trainning accuracy -- Fig2
        for i=1:length(M)
            m(1:length(N)) = M(i);
            [acc(i,:), t_loc(i,:),e_loc(i,:),t_up(i,:),e_up(i,:)] = experiment([device(1),device(2),device(3)],m,N,[1,0]);
        end
        
        figure
        x = M;
        y = acc(:,1)*100.00;
        plot(x,y) 
        hold on 
        y2 = acc(:,2)*100.00;
        plot(x,y2)
        hold on 
        y3 = acc(:,3)*100.00;
        plot(x,y3)
        legend('Number of local iterations N=8','Number of local iterations N=15','Number of local iterations N=25');
        xlabel('Number of global iterations (M)');
        ylabel('Traning accuracy (%)');
        title('The average training accuracy VS # of M under different N');
        grid on
        hold off
  elseif(type == 3)
        % Average Distance vs Energy Consumption where T = 166 s -- Fig3
        x = 50:10:150;
        for i=1:length(x)
%             for j = 1:k
                device(1).d = (x(i) * 0.2) * k;
                device(2).d = (x(i) * 0.3) * k;
                device(3).d = (x(i) * 0.5) * k;
%             end
            [acc(i,:), t_loc(i,:),e_loc(i,:),t_up(i,:),e_up(i,:)] = experiment([device(1),device(2),device(3)],M,N,[1,166]);
        end
        
        figure
        ratio = 1;
        y = (e_loc(:,1).*ratio)+e_up(:,1);
        plot(x,y)
        hold on 
        y2 = (e_loc(:,1).*ratio)+e_up(:,2);
        plot(x,y2)
        hold on 
        y3 = (e_loc(:,1).*ratio)+e_up(:,3);
        plot(x,y3)
        legend('NOMA (M=50, N=8)','NOMA (M=30, N=15)','NOMA (M=20, N=25)');
        xlabel('Average distance (m)');
        ylabel('Energy consumption (J)');
%         title('The energy consumption @ devices VS the # of FLOPs within a CPU cycle');
        grid on
        hold off
    elseif(type == 4)
        x = 1:15;
        % Number of FLOP vs Energy Consumption where T = 850 s. -- Fig4
        for i=x
            for j = 1:k
                device(j).c = i;
            end
            [acc(i,:), t_loc(i,:),e_loc(i,:),t_up(i,:),e_up(i,:)] = experiment([device(1),device(2),device(3)],M,N,[1,0]);
        end
        
        figure
        y = e_loc(x,1)+e_up(x,1);
        plot(x,y)
        hold on 
        y2 = e_loc(x,2)+e_up(x,2);
        plot(x,y2)
        hold on 
        y3 = e_loc(x,3)+e_up(x,3);
        plot(x,y3)
        legend('M=20, N=25','M=30, N=15','M=50, N=8');
        xlabel('Number of FLOPs within a CPU cycle');
        ylabel('Energy consumption (J)');
%         title('The energy consumption @ devices VS the # of FLOPs within a CPU cycle');
        grid on
        hold off
        
        figure
        y = e_loc(x,1);
        plot(x,y)
        hold on 
        y2 = e_loc(x,2);
        plot(x,y2)
        hold on 
        y3 = e_loc(x,3);
        plot(x,y3)
        legend('M=20, N=25','M=30, N=15','M=50, N=8');
        xlabel('Number of FLOPs within a CPU cycle');
        ylabel('Energy consumption (J)');
        title('The energy consumption @ local machine VS the # of FLOPs within a CPU cycle');
        grid on
        hold off
    elseif(type == 5)
%         fix M
        x = 10:10:100;
        for i=1:length(x)
            [acc(i,:), t_loc(i,:),e_loc(i,:),t_up(i,:),e_up(i,:)] = experiment([device(1),device(2),device(3)],M,i,[1,0]);
        end
        
        figure
        ratio = 1;
        y = (e_loc(:,1).*ratio)+e_up(:,1);
        plot(x,y)
        hold on 
        xlabel('Number of local iteration (N)');
        ylabel('Energy consumption (J)');
        grid on
        hold off
    elseif(type == 6)
%         fix N
        x = 10:10:100;
        for i=1:length(x)
            [acc(i,:), t_loc(i,:),e_loc(i,:),t_up(i,:),e_up(i,:)] = experiment([device(1),device(2),device(3)],i,N,[1,0]);
        end
        
        figure
        ratio = 1;
        y = (e_loc(:,1).*ratio)+e_up(:,1);
        plot(x,y)
        hold on 
        xlabel('Number of global iteration (M)');
        ylabel('Energy consumption (J)');
        grid on
        hold off
    elseif(type == 7)
%         fix N
        x = 10:10:100;
        for i=1:length(x)
            [acc(i,:), t_loc(i,:),e_loc(i,:),t_up(i,:),e_up(i,:)] = experiment([device(1),device(2),device(3)],i,N,[1,0]);
        end
        
        figure
        ratio = 1;
        y = (e_loc(:,1).*ratio)+e_up(:,1);
        plot(x,y)
        hold on 
        xlabel('Number of global iteration (M)');
        ylabel('Energy consumption (J)');
        grid on
        hold off
    end
end

