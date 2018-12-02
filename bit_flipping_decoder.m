%Performs Single BF Algorithm for regular LDPC
%Input: Received codeword after hard decoding (rx_codeword); Parity check
%matrix (h)

function bf_rx_codeword = bit_flipping_decoder(rx_codeword, h)

%Static variable definition.
lmax = 100; %Maximum number of iterations.
T = 0; %Treshold for the termination condition.

%Auxiliar variables.
v = rx_codeword;

%Determines size of h.
[~, N] = size(h);

%Calculates the syndrome.
s = double(mod(h*v',2));

if s == 0   
    v = rx_codeword; %Accepts the received codeword.
else 
    for l = 1:lmax
       %err_counter = zeros(1, N); %Initializes error counter.
        
        S = logical(s); %Determines the indexes of s whose values are different from 0.
        
        %Counts the number of errors that might be associated to each bit.
        err_counter=h(S,:);
        err_sum=sum(err_counter,1);
%         for i = S
%             err_counter=err_counter+h(i,:);
%             for j = 1:N
%                 if h(i,j) == 1
%                     err_counter(1, j) = err_counter(1,j) + 1;
%                 end
%             end
%         end
        
        [max_value, index] = max(err_sum); %Determines the maximum number of errors and its index.
        
        if max_value <= T %Error Treshold.
            break
        else
            v(index) = xor(v(index), 1);
        end
        
        %Updates syndrome.
       s = double(mod(h*v',2));
    end
end
    
    bf_rx_codeword = v;
end 