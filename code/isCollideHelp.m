function [ output_args ] = isCollideHelp( A1,A2,B1,B2 )
%ISCOLLIDEHELP �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
if  min(A1(1),A2(1)) <= max(B1(1),B2(1)) &&  min(B1(1),B2(1)) <= max(A1(1),A2(1)) &&  min(A1(2),A2(2)) <= max(B1(2),B2(2)) &&  min(B1(2),B2(2)) <= max(A1(2),A2(2))   %�����ų�ʵ��  
    if iscross(A1,A2,B1,B2) == 1
        output_args = 1;
    else  
        output_args = 0;
    end
else
    output_args = 0;
end
end

