function   [save_adress_name,figure_name]=image_add(M_raw0,M_noise_reduction,ijk,ij)
    r=size(M_raw0,1);
    c=size(M_raw0,2);
    mc0=M_raw0(:,:,:,1);
    mc1=M_noise_reduction(:,:,:,1);

    for k=1:ijk
        mc1 = imadd(mc1,M_noise_reduction(:,:,:,k));
        mc0 = imadd(mc0,M_raw0(:,:,:,k));
    end
    p=0;
    p=p+1;
    figure(p)
    imshow(mc0,'border','tight','InitialMagnification','fit' );
    set(gcf,'position',[360,200,500,500/c*r]);%设置图创大小
    save_adress_name{1,1}=strcat('D:\大论文\SEM\BSE\matlab\高清\物相图\第',num2str(ij),'次EDS未降噪合成物相图.fig');
    figure_name{1,1}=strcat('第',num2str(ij),'次EDS未降噪合成物相图');
    saveas(figure(p),save_adress_name{1,1});
    delete(figure(p))


    p=p+1;
    figure(p)
    imshow(mc1,'border','tight','InitialMagnification','fit' );
    set(gcf,'position',[360,200,500,500/c*r]);%设置图创大小
    save_adress_name{2,1}=strcat('D:\大论文\SEM\BSE\matlab\高清\物相图\第',num2str(ij),'次EDS合成物相图.fig');
    figure_name{2,1}=strcat('第',num2str(ij),'次EDS合成物相图');
    saveas(figure(p),save_adress_name{2,1});
    saveas(figure(p),strcat('D:\大论文\SEM\BSE\matlab\高清\物相图\第',num2str(ij),'次EDS合成物相图.jpg'));
    delete(figure(p))