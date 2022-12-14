function nsga_2_optimization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
%此处可以更改
pop = 600; %种群数量
gen = 500; %迭代次数
M = 2; %目标函数数量
V = 30; %维度（决策变量的个数）
min_range = zeros(1, V); %下界 生成1*30的个体向量 全为0
max_range = ones(1,V); %上界 生成1*30的个体向量 全为1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
chromosome = initialize_variables(pop, M, V, min_range, max_range);%初始化种群;chromosome是一个POP*(V+M)维矩阵
chromosome = non_domination_sort_mod(chromosome, M, V);%对初始化种群进行非支配快速排序和拥挤度计算;chromosome是一个POP*(V+M+2)维矩阵，加的2是个体的排序值和拥挤度

for i = 1 : gen
    pool = round(pop/2);%round() 四舍五入取整 交配池大小
    tour = 2;%竞标赛  参赛选手个数
    parent_chromosome = tournament_selection(chromosome, pool, tour);%竞标赛选择适合繁殖的父代
    mu = 20;%交叉和变异算法的分布指数
    mum = 20;
    offspring_chromosome = genetic_operator(parent_chromosome,M, V, mu, mum, min_range, max_range);%进行交叉变异产生子代 该代码中使用模拟二进制交叉和多项式变异 采用实数编码
    [main_pop,~] = size(chromosome);%父代种群的大小
    [offspring_pop,~] = size(offspring_chromosome);%子代种群的大小
    
    clear temp
    intermediate_chromosome(1:main_pop,:) = chromosome;
    intermediate_chromosome(main_pop + 1 : main_pop + offspring_pop,1 : M+V) = offspring_chromosome;%合并父代种群和子代种群
    intermediate_chromosome = non_domination_sort_mod(intermediate_chromosome, M, V);%对新的种群进行快速非支配排序
    chromosome = replace_chromosome(intermediate_chromosome, M, V, pop);%选择合并种群中前N个优先的个体组成新种群
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