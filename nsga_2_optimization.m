function nsga_2_optimization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
%�˴����Ը���
pop = 600; %��Ⱥ����
gen = 500; %��������
M = 2; %Ŀ�꺯������
V = 30; %ά�ȣ����߱����ĸ�����
min_range = zeros(1, V); %�½� ����1*30�ĸ������� ȫΪ0
max_range = ones(1,V); %�Ͻ� ����1*30�ĸ������� ȫΪ1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
chromosome = initialize_variables(pop, M, V, min_range, max_range);%��ʼ����Ⱥ;chromosome��һ��POP*(V+M)ά����
chromosome = non_domination_sort_mod(chromosome, M, V);%�Գ�ʼ����Ⱥ���з�֧����������ӵ���ȼ���;chromosome��һ��POP*(V+M+2)ά���󣬼ӵ�2�Ǹ��������ֵ��ӵ����

for i = 1 : gen
    pool = round(pop/2);%round() ��������ȡ�� ����ش�С
    tour = 2;%������  ����ѡ�ָ���
    parent_chromosome = tournament_selection(chromosome, pool, tour);%������ѡ���ʺϷ�ֳ�ĸ���
    mu = 20;%����ͱ����㷨�ķֲ�ָ��
    mum = 20;
    offspring_chromosome = genetic_operator(parent_chromosome,M, V, mu, mum, min_range, max_range);%���н����������Ӵ� �ô�����ʹ��ģ������ƽ���Ͷ���ʽ���� ����ʵ������
    [main_pop,~] = size(chromosome);%������Ⱥ�Ĵ�С
    [offspring_pop,~] = size(offspring_chromosome);%�Ӵ���Ⱥ�Ĵ�С
    
    clear temp
    intermediate_chromosome(1:main_pop,:) = chromosome;
    intermediate_chromosome(main_pop + 1 : main_pop + offspring_pop,1 : M+V) = offspring_chromosome;%�ϲ�������Ⱥ���Ӵ���Ⱥ
    intermediate_chromosome = non_domination_sort_mod(intermediate_chromosome, M, V);%���µ���Ⱥ���п��ٷ�֧������
    chromosome = replace_chromosome(intermediate_chromosome, M, V, pop);%ѡ��ϲ���Ⱥ��ǰN�����ȵĸ����������Ⱥ
    if ~mod(i,100)
        clc;
        fprintf('%d generations completed\n',i);
    end
end


if M == 2
    plot(chromosome(:,V + 1),chromosome(:,V + 2),'*');
    xlabel('f_1'); ylabel('f_2');
    title('Pareto Optimal Front');
    toc
elseif M == 3
    plot3(chromosome(:,V + 1),chromosome(:,V + 2),chromosome(:,V + 3),'*');
    xlabel('f_1'); ylabel('f_2'); zlabel('f_3');
    title('Pareto Optimal Surface');
   
end