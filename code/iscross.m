function[output_args] = iscross(A1,A2,B1,B2)                           %¿çÁ¢ÊµÑé  
    A1B1 = A1 -B1;  
    B2B1 = B2 - B1;  
    A2A1 = A2 - A1; 
    B2A1 = B2 -A1; 
    A2B1 = A2 - B1;
    B1A1 = B1 - A1;
    if vector_product(A1B1,B2B1)*vector_product(B2B1,A2B1)>=0   
        if vector_product(B1A1,A2A1)*vector_product(A2A1,B2A1)>=0 
            output_args = 1;  
        else  
            output_args = 0;   
        end
    else  
        output_args = 0;  
    end
end