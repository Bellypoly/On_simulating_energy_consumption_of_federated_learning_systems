function plot_signal(x1, x2, x3, demodulation, block, type)

    %Plot figures
    ay = -2:0.2:2;
    ax = ones(1,length(ay));
    
    if(demodulation ~= 0)     
        QPSKdemod = comm.QPSKDemodulator('BitOutput',true); 
        x1 = step(QPSKdemod, x1);
        x2 = step(QPSKdemod, x2);
        x3 = step(QPSKdemod, x3);
        
        x1 = x1';
        x2 = x2';
        x3 = x3';
    end
    
    if(type == 1)
        title_name = [  "Data @ Device 1 ($${x_1}$$)",...
                        "Data @ Device 2 ($${x_2}$$)",...
                        "Data @ Device 3 ($${x_3}$$)"];
    elseif(type == 2)
        title_name = [  "QPSK data @ Device 1",...
                        "QPSK data @ Device 2",...
                        "QPSK data @ Device 3"];
    elseif(type == 3)
        title_name = [  "Superposition encoding @ Device 1 ($$\sqrt{p_1h_1}x_1$$)",...
                        "Superposition encoding @ Device 2 ($$\sqrt{p_2h_2}x_2$$)",...
                        "Superposition encoding @ Device 3 ($$\sqrt{p_3h_3}x_3$$)"];
    elseif(type == 4)
        title_name = "Superposition coded signal";
    end
    
    if(block == 1)
        figure;
        stairs([x1,x1(end)],'r','linewidth',2);
        grid on; hold on;
        title(title_name,'Interpreter','latex','FontSize',11)
        for u = 1:3
           plot(ax*(u+1),ay,':k','linewidth',2);  
        end
    elseif(block == 3)
        figure;
        subplot(3,1,1)
        stairs([x1,x1(end)],'linewidth',2);
        ylim([-2 2])
        grid on; hold on;
        title(title_name(1),'Interpreter','latex','FontSize',11);
        for u = 1:3
           plot(ax*(u+1),ay,':k','linewidth',2);  
        end
        
        subplot(3,1,2)
        stairs([x2,x2(end)],'m','linewidth',2);
        ylim([-2 2])
        grid on; hold on;
        title(title_name(2),'Interpreter','latex','FontSize',11)
        for u = 1:3
           plot(ax*(u+1),ay,':k','linewidth',2);  
        end
        
        subplot(3,1,3)
        stairs([x3,x3(end)],'r','linewidth',2);
        ylim([-2 2])
        grid on; hold on;
        title(title_name(3),'Interpreter','latex','FontSize',11)
        for u = 1:3
           plot(ax*(u+1),ay,':k','linewidth',2);  
        end
    end
end

