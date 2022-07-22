clc
clear
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%需修改的东西%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
EDS_mapping_address='D:\大论文\SEM\BSE\matlab\高清\';%原始数据存储位置,储存方式为每种元素一个文件夹，以元素名字命名，里面图片为tif格式，文件名为元素名称后紧跟次数编号，如1，2，3，
filename='浸泡在10%硫酸钠溶液中水灰比0.58的净浆';%样本名称
Word_address='D:\大论文\SEM\BSE\matlab\样本1\处理数据\EDS处理报告';%Word储存的位置
element=["S","Ca","Al","O","Na","Fe"];
threshold=[0.45,0.2,0.45,0.2,0.45,0.45];%判断临界值设定,和元素个数相一致
Interval_pixels=20;%判断周围Interval_pixels个像素点范围内二值平均值
N=11;%面扫次数
Height_initowial_end=70:1580;%从左上角到左下角%不用剪切时，填图片本身的像素点，如1688*2548，则Height_initowial_end=1:1688
Width_initowial_end=20:1950;%从左上角到右上角%不用剪切时，填图片本身的像素点，如1688*2548，则Width_initowial_end=1:2548
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
filespec_user = (strcat(Word_address,filename,'.doc'));% 设定测试Word文件名和路径
[Word,Document,Content,Selection]=word_active_and_open(filespec_user);%word得激活和创建
L=word_PageSetup(Document);%% 页面设置
Content.Start = 0;%设定光标位置
Paragraphformat = Selection.ParagraphFormat;

Num.figures=1;n_table=1;Num.equation=1;Num.Table=1;Num.refer=1;%用于记录图片、表格、公式、参考文献得个数
%% %%%%%%%%%%%%%%%%%%%%%%%%标题%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
title = strcat(filename,"EDS Mapping数据处理报告");
Content.Text = title;L=set_format_title1(Content);%字体和段落格式设定
%%
n_title2=0;n_title3=1;n_title4=1;%用于记录二级，三级，四级标题
Selection.Start = Content.end;Selection.TypeParagraph;% 定义开始的位置为上一段结束的位置%换行插入内容并定义字体字号
Title1 = strcat(num2str(n_title2),'. 数据处理过程描述');n_title2=n_title2+1;
Selection.Text = Title1;L=set_format_title2(Selection);%格式设定

Selection.Start = Content.end;Selection.TypeParagraph;% 定义开始的位置为上一段结束的位置%换行插入内容并定义字体字号
[T1_content] =Title1_content();

for i=1:size(T1_content)%不同段落的写入
    Selection.Text = T1_content{i,1};L=set_format_for_text(Selection);
    Selection.Start = Content.end;Selection.TypeParagraph;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic
for ij=1:N
    Selection.Start = Content.end;Selection.TypeParagraph;% 定义开始的位置为上一段结束的位置%换行插入内容并定义字体字号
    Title1 = strcat(num2str(n_title2),'. 第',num2str(ij),'次EDS测试');n_title2=n_title2+1;n_title3=1;
    Selection.Text = Title1;L=set_format_title2(Selection);%格式设定
    for ijk=1:size(element,2)
        Num0=Num;
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%原图%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        m1 = imread(strcat( EDS_mapping_address,element(ijk),'\',element(ijk),num2str(ij),'.tif'));
        %       M_raw=m1(900:1200,100:500,1:3);%图片切割
        M_raw=m1(Height_initowial_end,Width_initowial_end,1:3);%图片切割
        M_raw0(:,:,:,ijk)=M_raw;
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%降噪%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [save_adress_name,figure_name,M_noise_reduction(:,:,:,ijk),C0(ijk,ij),C1(ijk,ij)]=noise_reduction(M_raw,threshold(ijk),Interval_pixels,element,ijk,ij);
        %%
        Selection.Start = Content.end;Selection.TypeParagraph;% 定义开始的位置为上一段结束的位置%换行插入内容并定义字体字号
        Title1 = strcat(num2str(n_title2-1),".",num2str(n_title3),". ",element(ijk),"元素Mapping");n_title3=n_title3+1;
        Selection.Text = Title1;L=set_format_title3(Selection);%格式设定
        %----------------------------------插入图片--------------------------------
        Selection.Start = Content.end;Selection.TypeParagraph;% 定义开始的位置为上一段结束的位置%换行插入内容并定义字体字号
        n_rows=5;n_columns=2;
        figure_title=strcat(" ",element(ijk),'元素第',num2str(ij),'次的EDS处理图');
        [Document,Selection,n_table,Num]=tables_figures_and_name(Document,Selection,save_adress_name,figure_name,figure_title,n_rows,n_columns,Num,n_table);
    end

    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%叠加%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [save_adress_name,figure_name]=image_add(M_raw0,M_noise_reduction,ijk,ij);
    %----------------------------------插入图片--------------------------------
    Selection.Start = Content.end;Selection.TypeParagraph;% 定义开始的位置为上一段结束的位置%换行插入内容并定义字体字号
    n_rows=3;n_columns=2;
    figure_title=strcat('第',num2str(ij),'次EDS物相合成图');
    [Document,Selection,n_table,Num]=tables_figures_and_name(Document,Selection,save_adress_name,figure_name,figure_title,n_rows,n_columns,Num,n_table);
    toc
end

for ijk=1:size(element,2)

    Selection.Start = Content.end;Selection.TypeParagraph;% 定义开始的位置为上一段结束的位置%换行插入内容并定义字体字号
    n_rows=3;n_columns=12;
    table_name=strcat("Distribution of ",element(ijk)," element within EDS mapping without noise reduction");
    table_content_t=["$225\mu\,m$","$225\mu\,m$","$225\mu\,m$","$225\mu\,m$","$225\mu\,m$","$225\mu\,m$","$225\mu\,m$","$225\mu\,m$","$225\mu\,m$","$225\mu\,m$","$225\mu\,m$" ];
    table_content_v=element(ijk);
    table_data=C0(ijk,:);
    [n_table,Content,Num]=tables_Tables_and_name(Document,Content,Selection,n_rows,n_columns,table_data,table_name,table_content_t,table_content_v,Num,n_table);
    Selection.Start = Content.end;Selection.TypeParagraph;% 定义开始的位置为上一段结束的位置%换行插入内容并定义字体字号

    n_rows=3;n_columns=12;
    table_name=strcat("Distribution of ",element(ijk)," element within EDS mapping after noise reduction");
    table_content_t=["$225\mu\,m$","$225\mu\,m$","$225\mu\,m$","$225\mu\,m$","$225\mu\,m$","$225\mu\,m$","$225\mu\,m$","$225\mu\,m$","$225\mu\,m$","$225\mu\,m$","$225\mu\,m$" ];
    table_content_v=element(ijk);
    table_data=C1(ijk,:);
    [n_table,Content,Num]=tables_Tables_and_name(Document,Content,Selection,n_rows,n_columns,table_data,table_name,table_content_t,table_content_v,Num,n_table);
end



% Dis = dir(Address_original_address);
% DirCell=struct2cell(Dis);
% filename0 = sort_nat(DirCell(1,3:end));%带后缀的CSV文件名字
% filename0=filename0';
% for i=1:size(filename0,1)
%     filename01=cell2mat(filename0(i,1));
%     j = find('.'==filename01);
% end