pkg load image 

clc
clear all 
close all 

function C = erode(im)
  B = [1 1 1; 1 1 1; 1 1 1];
  C = im;
  for i=2:size(im,1)-1
    for j=2:size(im,2)-1
      if(im(i,j)== 1) %se o pixel central da vizinhanca de A = 1, deve ser analizado
        vizA = [im(i-1,j-1) im(i-1,j) im(i-1,j+1);...
              im(i,j-1) im(i,j) im(i,j+1);...
              im(i+1,j-1) im(i+1,j) im(i+1,j+1)];
        if (sum(sum(vizA==B))!=9) % se todos os pixels sao iguais entre a vizinhancade A e B
          C(i,j)=0;
        end    
      end
    end
  end
endfunction


tic %tic toc padr�o, s� para verificar o tempo de execu��o da imagem do banco
im = imread('C:\Users\pedro\Desktop\projetoPDI\aquisicao\img-27.jpg')
figure('name','Figura 1 - Imagem Original'), imshow(im);
toc


% Separando os canais de cores RGB;
r = im(:,:,1)
%figure('name', 'canal - r'), imhist(r)

g = im(:,:,2)
%figure ('name', 'canal g'), imhist(g)

b = im(:,:,3)
%figure('name', 'canal - b'), imhist(b)

im2 = b-r ;
%figure('name', 'Fundo Preto'), imshow(fundoPreto);
 
%==========| HISTOGRAMA |==========%
%Mostrando histograma da imagem original
%figure('name', 'Histograma - Imagem Original'), imhist(im);
 
%Enviando a imagem original para o histograma
histo = imhist(im2);
 
%Pegando o segundo pico presente no histograma
pico2 = 0; 
indicePico2 = 0;
for i = 2 : 256
  if (histo(i) > pico2)
    pico2 = histo(i);
    indicePico2 = i; 
  endif
endfor
  
%A procura do vale entre os dois picos do histograma
vale = max(histo); % Valor do maior pico do histograma 
indiceVale = 0;
for i = 2 : indicePico2
  if (histo(i) < vale);
    vale = histo(i);
    indiceVale = i;
  endif
endfor 
 
%==========| LIMIARIZA��O DA IMAGEM |==========%
limi = ~(im2>indiceVale);
 
semFundo = zeros(size(im,1),size(im,2),3, 'uint8');
semFundo = im.*limi; %para cada elemento(pixel) sera multiplicado o valor correspondente no binario (i,j) * 0 = 0 OU (i,j)*1 = (i,j)
 
imCinza = rgb2gray(semFundo)
 
%==========| BINARIZA��O DA IMAGEM |==========%
imBinaria = zeros(size(semFundo, 1), size(semFundo, 2));
imBinaria(imCinza>limi) = 1;
figure('NAME', 'Imagem Binarizada'), imshow(imBinaria);
 
%==========| ERODINDO A IMAGEM |==========%
C = erode(imBinaria);
figure('name','imagem erodida'), imshow(C);
 
%==========| ROTULA��O DA IMAGEM |==========%
[rotulo, num] = bwlabel(C);
figure('NAME', 'Imagem Rotulada');
imshow(rotulo, []);
title(strcat( 'Quantidade de Objetos (Foreground): ', int2str(num)));
colormap(jet), colorbar;

%==========| SEPARANDO A IMAGEM ROTULADA EM VARIAS IMAGENS |==========%
vetor = unique(rotulo);
MatrizOrange  = zeros(size(rotulo, 1), size(rotulo, 2), size(vetor,1));

cont = 1; 

for y = 2:size(vetor, 1)
  for i = 1:size(rotulo, 1)
    for j = 1:size(rotulo, 2)
      if vetor(y) == rotulo(i,j)
        MatrizOrange(i, j, cont) = 1;
      else
        MatrizOrange(i, j, cont) = 0;
      endif
    endfor 
  endfor
  cont++;
endfor

for i = 1:num
figure(i);
imshow(MatrizOrange(:,:,i));
end

%Guardar cada objeto em uma dimens�o da imagem nova 
corR = zeros(size(vetor,1)-1);
corG = zeros(size(vetor,1)-1);
corB = zeros(size(vetor,1)-1);
    
cont = 0;
  
for i=1:size(MatrizOrange,1)
  for j=1:size(MatrizOrange,2)
    for x=1:size(MatrizOrange,3)
        if MatrizOrange(i,j,x) == 1
           corR(x) = corR(x) + sum(semFundo(i,j,1));
           corG(x) = corG(x) + sum(semFundo(i,j,2));
           corB(x) = corB(x) + sum(semFundo(i,j,3));
           cont = cont + 1;
        end
    end
  end  
end 

for k=1:size(corR,1)
  cores(k,1) = corR(k)/cont;
end

for k=1:size(corG,1)
  cores(k,2) = corG(k)/cont;
end

for k=1:size(corB,1)
  cores(k,3) = corB(k)/cont;
end

%disp("-------- Media de Cores ----------")
%disp(cores)

ContMaduro = 0;
ContVerde = 0;


disp("----------------------------------")
disp("----------- RESULTADO FINAL ------------")
disp("----------------------------------")

for p=1:size(cores,1)
  
   if (cores(p,1) > 47 && cores(p,1) < 90) && (cores(p,2) > 90 && cores(p,2) < 132.32) 
     ContMaduro++;
     disp("Laranja madura na posicao:"),disp(p)
  
   else
       disp("Laranja verde na posicao:"),disp(p)
       ContVerde++;
    end       
  end 

disp("----------------------------------")
disp("------ Quantidade -------")  
disp("----------------------------------")
disp("Quantidade de laranjas madura:"),disp(ContMaduro)
disp("Quantidade de laranjas verde:"),disp(ContVerde)

%plotando imagem original
 u = im;
 figure('NAME','imagem final')
 imshow(u)
