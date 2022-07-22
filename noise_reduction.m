
function [save_adress_name,figure_name,M_procesed,C_initial,C_end]=noise_reduction(M0,threshold,Interval_pixels,element,ijk,ij)
M00=M0;
r=size(M0,1);
c=size(M0,2);
N=r*c;
p=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%原图二值化%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
M1=rgb2gray(M0);
thresh=graythresh(M1);     %自动确定二值化阈值
M_i2=imbinarize(M1,thresh);       %对图像二值化
M2=M_i2(:);%将二维向量化为一维，按列排

I=repelem(1:c,1,r);%产生1，1，1，2，2，2，3，3，3......%
J=repmat(1:r,1,c);%产生1，2，3，1，2，3，1，2，3......
node_position(1:N,1)=J;
node_position(1:N,2)=I;

n_r= node_position(1:N,1);
n_c= node_position(1:N,2);

n_r_initial=n_r-Interval_pixels;
n_r_initial(n_r-Interval_pixels<=0)=1;
n_r_end=n_r+Interval_pixels;
n_r_end(n_r+Interval_pixels>=r)=r;

n_c_initial=n_c-Interval_pixels;
n_c_initial(n_c-Interval_pixels<=0)=1;
n_c_end=n_c+Interval_pixels;
n_c_end(n_c+Interval_pixels>=c)=c;

N_1(r,c)=0;
for n=1:N
    f1=M_i2(n_r_initial(n):n_r_end(n),n_c_initial(n):n_c_end(n));
    N_0=sum(sum(f1==1))/(size(f1,1)*size(f1,2));
    N_1(node_position(n,1),node_position(n,2))=N_0;
    if N_0<threshold
        M2(n)=0;
        M0(node_position(n,1),node_position(n,2),:)=0;
        N_1(node_position(n,1),node_position(n,2))=0;
    end
end

toc

M_i2_proposed= reshape(M2,r,c);
M_procesed=M0;

C_initial=sum(sum(M_i2>0))/(size(M_i2,1)*size(M_i2,2));
C_end=sum(sum(M_i2_proposed>0))/(size(M_i2_proposed,1)*size(M_i2_proposed,2));
M_contour=flipud(N_1);
M_contour(M_contour<=threshold)=0;


p=p+1;
figure(p)
imshow(M00,'border','tight','InitialMagnification','fit' );
set(gcf,'position',[360,200,500,500/c*r]);%设置图创大小
save_adress_name{1,1}=strcat('D:\大论文\SEM\BSE\matlab\高清\',element(ijk),'\',element(ijk),'_raw_',num2str(ij),'.fig');
figure_name{1,1}=strcat(element(ijk),'元素第',num2str(ij),'次EDS面扫图');
saveas(figure(p),save_adress_name{1,1});
delete(figure(p))


p=p+1;
figure(p)
imshow(M_i2,'border','tight','InitialMagnification','fit' );
set(gcf,'position',[360,200,500,500/c*r]);%设置图创大小
save_adress_name{2,1}=strcat('D:\大论文\SEM\BSE\matlab\高清\',element(ijk),'\',element(ijk),'_raw2gra_',num2str(ij),'.fig');
figure_name{2,1}=strcat(element(ijk),'元素第',num2str(ij),'次EDS面扫二值化');
saveas(figure(p),save_adress_name{2,1});
delete(figure(p))

% p=p+1;
% figure(p)
% imshow(M_i2_proposed,'border','tight','InitialMagnification','fit' );
% set(gcf,'position',[360,200,500,500/c*r]);%设置图创大小


p=p+1;
figure(p)
imshow(M_procesed,'border','tight','InitialMagnification','fit' );
set(gcf,'position',[360,200,500,500/c*r]);%设置图创大小
save_adress_name{3,1}=strcat('D:\大论文\SEM\BSE\matlab\高清\',element(ijk),'\',element(ijk),'_noise reduction_',num2str(ij),'.fig');
figure_name{3,1}=strcat(element(ijk),'元素第',num2str(ij),'次EDS面扫降噪图');
saveas(figure(p),save_adress_name{3,1});
delete(figure(p))

p=p+1;
figure(p)
Y = linspace(1,size(M_i2,1),r);
X = linspace(1,size(M_i2,2),c);
contourf(X, Y, M_contour)
set(gcf,'position',[360,200,500,500/c*r]);%设置图创大小
set(gcf, 'Color', 'w');%设定背景颜色为白色
set (gca,'position',[0,0,1,1] );
save_adress_name{4,1}=strcat('D:\大论文\SEM\BSE\matlab\高清\',element(ijk),'\',element(ijk),'_contour_',num2str(ij),'.fig');
figure_name{4,1}=strcat(element(ijk),'元素第',num2str(ij),'次EDS面扫等高线图');
saveas(figure(p),save_adress_name{4,1});
delete(figure(p))







%
% n=0;
% for i=1:c
%     for j=1:r
%     n=n+1;
%     node_XY(j,1)=(i-1)*dx+dx/2;
%     node_XY(j,2)=(r-1)*dy+dy/2;
%     node_position(j,1)=j;
%     node_position(j,2)=i;
%     end
% end


% for i=1:c
%     node_XY(r*(i-1)+1:r*i,1)=(i-1)*dx+dx/2;
%     node_XY(r*(i-1)+1:r*i,2)=((1:r)'-1)*dy+dy/2;
%     node_position(r*(i-1)+1:r*i,1)=(1:r)';
%     node_position(r*(i-1)+1:r*i,2)=i;
% end


%     I=repelem(1:c,1,r);%产生1，1，1，2，2，2，3，3，3......%
%     J=repmat(1:r,1,c);%产生1，2，3，1，2，3，1，2，3......
%     node_XY(1:N,1)=I*dx+dx/2;
%     node_XY(1:N,2)=(J-1)*dy+dy/2;
%     node_position(1:N,1)=J;
%     node_position(1:N,2)=I;


%     for i=1:size(M2,1)
%         d=sqrt((node_XY(i,1)-node_XY(n,1))^2+(node_XY(i,2)-node_XY(n,2))^2);
%             if d<=Interval_pixels*dx
%                 nn=nn+1;
%                 node_couple0(nn,1) = i;
%             end
%     end


%     nn=0
%     for i=n_r_initial:n_r_end
%      for   j=n_c_initial:n_c_end;
%         d=sqrt((j-0.5-node_XY(n,1)).^2+(i-0.5-node_XY(n,2))^2);
%         if d<=Interval_pixels*dx
%           nn=nn+1;
%           node_couple0(nn,1) = i;
%           node_couple0(nn,2) = j;
%         end
%      end
%     end


%     for i=n_r_initial:n_r_end
%         j=n_c_initial:n_c_end;
%         d=sqrt((j-0.5-node_XY(n,1)).^2+(i-0.5-node_XY(n,2))^2);
%         v=find(d<=Interval_pixels*dx);
%
%         node_couple0(nn+1:nn+size(v,2),1) = i;
%         node_couple0(nn+1:nn+size(v,2),2) = v+n_c_initial-1;
%         nn=nn+size(v,2);
%     end




% n_r= node_position(n,1);
%     n_c= node_position(n,2);
%
%     if n_r-Interval_pixels>0
%         n_r_initial=n_r-Interval_pixels;
%     else
%         n_r_initial=1;
%     end
%
%     if n_r+Interval_pixels<r
%         n_r_end=n_r+Interval_pixels;
%     else
%         n_r_end=r;
%     end
%
%     if n_c-Interval_pixels>0
%         n_c_initial=n_c-Interval_pixels;
%     else
%         n_c_initial=1;
%     end
%
%     if n_c+Interval_pixels<c
%         n_c_end=n_c+Interval_pixels;
%     else
%         n_c_end=c;
%     end
%
%
%         i=(n_r_initial:n_r_end)';
%         j=n_c_initial:n_c_end;
%         a=(j-0.5-node_XY(n,1)).^2;
%         b=(i-0.5-node_XY(n,2)).^2;
%         d=sqrt(a+b);
%         [v1,v2]=find(d<=Interval_pixels*dx);
%
%         node_couple0(1:size(v1,1),1) = v1+n_r_initial-1;
%         node_couple0(1:size(v1,1),2) = v2+n_c_initial-1;

%         i=(n_r_initial:n_r_end)';%行循环
%         j=n_c_initial:n_c_end;%行循环
%         a=(j-0.5-node_XY(n,1)).^2;%x方向距离
%         b=(i-0.5-node_XY(n,2)).^2;%y方向距离
%         d=sqrt(a+b);%进行排列组合
%         [v1,v2]=find(d<=Interval_pixels*dx);%找出距离小于
%         node_couple0(1:size(v1,1),1) = v1+n_r_initial-1;
%         node_couple0(1:size(v1,1),2) = v2+n_c_initial-1;
%         f1=M_i2(node_couple0(:,1),node_couple0(:,2));









%     f1=M2(node_couple0(:,1));
%     N_0=sum(sum(f1==1))/size(f1,1);
%     if N_0<threshold
%         M2(n)=0;
%         M0(node_position(n,1),node_position(n,2),:)=0;
%     end
%     N_1(node_position(n,1),node_position(n,2))=N_0;



