function biseccion()
  manejador.figure = figure ( ...
    'name', 'Buscador de raíces', ...
    'position', [100, 100, 420, 300]); 
  
  manejador.ControlTexto = uicontrol (manejador.figure, ...
    'style', 'text', ...
    'string', 'f(x) =', ...
    'position', [10 250 200 40]);
  
  manejador.ControlFuncion = uicontrol (manejador.figure, ...
    'style', 'edit', ...
    'string', '0', ...
    'position', [210 250 200 40]);
  
  manejador.ControlTexto2 = uicontrol (manejador.figure, ...
    'style', 'text', ...
    'string', 'Límite inferior x1=', ...
    'position', [10 200 200 40]);
  
  manejador.ControlLimInf = uicontrol (manejador.figure, ...
    'style', 'edit', ...
    'string', '0', ...
    'callback', @validar_real, ...
    'position', [210 200 200 40]);
  
  manejador.ControlTexto3 = uicontrol (manejador.figure, ...
    'style', 'text', ...
    'string', 'Límite superior xu=', ...
    'position', [10 150 200 40]);
  
  manejador.ControlLimSup = uicontrol (manejador.figure, ...
    'style', 'edit', ...
    'string', '0', ...
    'callback', @validar_real, ...
    'position', [210 150 200 40]);
 
  manejador.ControlTexto4 = uicontrol (manejador.figure, ...
    'style', 'text', ...
    'string', 'Error máximo (%) Ea=', ...
    'position', [10 100 200 40]);
  
  manejador.ControlError = uicontrol (manejador.figure, ...
    'style', 'edit', ...
    'string', '0', ...
    'callback', @validar_error, ...
    'position', [210 100 200 40]);
    
  manejador.ControlResolver = uicontrol (manejador.figure, ...
    'style', 'pushbutton', ...
    'string', 'Encontrar raíz', ...
    'callback', @encontrar_raiz, ...
    'position', [10 50 400 40]);

  manejador.ControlRaiz = uicontrol (manejador.figure, ...
    'style', 'text', ...
    'string', 'Raíz: x = ', ...
    'position', [10 0 400 40]);
  
  guidata(manejador.figure, manejador);
end

function validar_real (hObject, ~)
  modoNum = str2double(get(hObject, 'string'));
  if isnan(modoNum)
    set(hObject, 'string', '0');
  end
end

function validar_error (hObject, ~)
  modoNum = str2double(get(hObject, 'string'));
  if isnan(modoNum) || modoNum < 0 || modoNum > 99.9
    set(hObject, 'string', '0');
  end
end

function encontrar_raiz(~, ~)
  pkg load symbolic;
  syms x;
  e_aprox=100;
  xactual=1;
  cont=0;
  x_r=0;
  
  manejador = guidata(gcf);
  try
    fx = sym(get(manejador.ControlFuncion, 'String'));
    x1 = str2double(get(manejador.ControlLimInf, 'String'));
    xu = str2double(get(manejador.ControlLimSup, 'String'));
    aproximado = str2double(get(manejador.ControlError, 'String'));
  
    fx1=subs(fx,x,x1);
    fxu=subs(fx,x,xu);
    
    if(x1>xu)
      error('Intervalo:incorrecto', ...
          '\n No se ingreso el intervalo correcatmente');
    end
    disp(fx1*fxu > 0);
    if(fx1*fxu >= 0)
        error('Intervalo:sin_raiz', ...
            'No existe raíz en el intervalo');
    end
    %mientras que la tolerncia 1 sema mayor a la 2
    while(e_aprox>aproximado)
    
      cont=cont+1;
      xr=(x1+xu)/2; % la mitad
      
      fxr=subs(fx,x,xr);    % sustituir xr
      xanterior=xactual;
      xactual=xr;
   
      %en mi funcion fx rempazas x con xr 
      fx1=subs(fx,x,x1);
      fxu=subs(fx,x,xu);
      
      %casos
      if((fxr*fx1)<0)
        xu=xr;
      end
    
      if((fxr*fx1)>0)
        x1=xr;
      end
   
      if(cont>1)
        e_aprox=((abs(xactual-xanterior))/xactual)*100;
      end
      fprintf('\n Iteracion %d, intervalo [%f][%f]',cont,x1,xu);
      if((fxr)*(fx1)==0)
        break;
      end
    end
    fprintf('\n Raiz de f(x)= %f\n',xr);
    set(manejador.ControlRaiz, 'string', strcat('Raíz: x = ', num2str(xr), ...
        ' (en  ', num2str(cont), ' iteraciones)'));
  catch ex
     disp(ex.message);
    if strcmp(ex.identifier, 'Intervalo:incorrecto')
      set(manejador.ControlRaiz, 'string', ['No se ingreso el intervalo' ...
          ' correctamente']);
    elseif strcmp(ex.identifier, 'Intervalo:sin_raiz')
      set(manejador.ControlRaiz, 'string', ['No existe raíz en el ' ...
          'intervalo']);
    else
      set(manejador.ControlRaiz, 'string', 'Función inválida');
    end
  end
end
