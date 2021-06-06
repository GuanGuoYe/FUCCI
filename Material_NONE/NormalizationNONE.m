  % Mission 1 : Data Import
  
    load('WorkSpace_CellName00000')           ;
    DataGreenPLUS=cell(size(CellName))        ; DataRedPLUS=cell(size(CellName))   ; WholeJourney=0 ; PartialJourney=0 ;
    tpGreen=250 ; tpRed=240 ; resolutionGreen=84.5/60  ; resolutionRed=84.5/60     ; % Parameter Setting
for k0=1:length(CellName)
    WholeJourney=WholeJourney+size(CellName{k0,1},1)   ;
end

    Data=importdata('CYB-1_GREEN.csv')        ; % Path of CYB-1 File
    N=Data.data ; N=N(:,2)  ; C=Data.textdata ; C=C(2:size(C,1),1) ; DataGreen={}  ;
for I=1:length(N)
    DataGreen{end+1,1}=C{I,1}(1:strfind(C{I,1},':')-1) ; DataGreen{end  ,3}=N(I,1) ;
    DataGreen{end  ,2}=str2num(C{I,1}(strfind(C{I,1},':')+1:end))*resolutionGreen  ;
end
for k0=1:length(CellName)
    Expression=cell(size(CellName{k0,1}))     ;
for k1=1:size(CellName{k0,1},1)
    PartialJourney=PartialJourney+1           ; PartialJourney/2/WholeJourney
for k2=1:size(CellName{k0,1},2)
if  isnumeric(CellName{k0,1}{k1,k2})==0
    for I=1:size(DataGreen,1)
    if  strcmp(CellName{k0,1}{k1,k2},DataGreen{I,1})==1 && DataGreen{I,2}<=tpGreen*resolutionGreen
        Expression{k1,k2}=[Expression{k1,k2},[DataGreen{I,2};DataGreen{I,3}]]      ;
    end
    end
end
end
end
    DataGreenPLUS{k0,1}=Expression ;
end
    DataGreen=DataGreenPLUS        ; save('Storage\WorkSpace_DataGreen','DataGreen','-v7.3') ;

    Data=importdata('CDT-1_RED.csv'  )        ; % Path of CDT-1 File
    N=Data.data ; N=N(:,2)  ; C=Data.textdata ; C=C(2:size(C,1),1) ; DataRed={}    ;
for I=1:length(N)
    DataRed{end+1,1}=C{I,1}(1:strfind(C{I,1},':')-1)   ; DataRed{end  ,3}=N(I,1)   ;
    DataRed{end  ,2}=str2num(C{I,1}(strfind(C{I,1},':')+1:end))*resolutionRed      ;
end
for k0=1:length(CellName)
    Expression=cell(size(CellName{k0,1}))     ; k0
for k1=1:size(CellName{k0,1},1)
    PartialJourney=PartialJourney+1           ; PartialJourney/2/WholeJourney
for k2=1:size(CellName{k0,1},2)
if  isnumeric(CellName{k0,1}{k1,k2})==0
    for I=1:size(DataRed,1)
    if  strcmp(CellName{k0,1}{k1,k2},DataRed{I,1})==1 && DataRed{I,2}<=tpRed*resolutionGreen
        Expression{k1,k2}=[Expression{k1,k2},[DataRed{I,2};DataRed{I,3}]]          ;
    end
    end
end
end
end
    DataRedPLUS{k0,1}=Expression ;
end 
    DataRed=DataRedPLUS ; save('Storage\WorkSpace_DataRed','DataRed','-v7.3')      ;



  % Mission 2 : Normalization A (Turning Point)
  
    load('WorkSpace_CellName00000')     ;
    load('Storage\WorkSpace_DataGreen') ; load('Storage\WorkSpace_DataRed')   ; Turning=[60,130,200] ;
    tpGreen=250 ; tpRed=240 ; resolutionGreen=84.5/60 ; resolutionRed=84.5/60 ; % Parameter Setting
for T=1:length(Turning)
    Cell1={}    ; Cell2={}  ; Cell3={}  ;
for k0=1:length(DataGreen)
for k1=1:size(DataGreen{k0,1},1)
for k2=1:size(DataGreen{k0,1},2)
if  isempty(DataGreen{k0,1}{k1,k2})==0
        t=find(DataGreen{k0,1}{k1,k2}(1,:)==(Turning(T)+0)*resolutionGreen)   ;
    if  isempty(t)==0
        Cell1{end+1,1}=CellName{k0,1}{k1,k2}          ;
    end
        t=find(DataGreen{k0,1}{k1,k2}(1,:)==(Turning(T)+1)*resolutionGreen)   ;
    if  isempty(t)==0
        Cell2{end+1,1}=CellName{k0,1}{k1,k2}          ;
    end
end
end
end
end
for I=1:size(Cell1,1)
for i=1:size(Cell2,1)
if  strcmp(Cell1{I,1},Cell2{i,1})==1
    Cell3{end+1,1}=Cell1{I,1}                ;
end
end
end
    Expression1=[] ; Expression2=[]          ;
for I=1:size(Cell3,1)
for k0=1:length(DataGreen)
for k1=1:size(DataGreen{k0,1},1)
for k2=1:size(DataGreen{k0,1},2)
if  isempty(DataGreen{k0,1}{k1,k2})==0 && strcmp(CellName{k0,1}{k1,k2},Cell3{I,1})==1
    t=find(DataGreen{k0,1}{k1,k2}(1,:)==(Turning(T)+0)*resolutionGreen)       ;
    Expression1=[Expression1,DataGreen{k0,1}{k1,k2}(2,t)]                     ;
    t=find(DataGreen{k0,1}{k1,k2}(1,:)==(Turning(T)+1)*resolutionGreen)       ;
    Expression2=[Expression2,DataGreen{k0,1}{k1,k2}(2,t)]                     ;
end
end
end
end
end
    Ratio=mean(Expression2)/mean(Expression1) ;
for k0=1:length(DataGreen)
for k1=1:size(DataGreen{k0,1},1)
for k2=1:size(DataGreen{k0,1},2)
if  isempty(DataGreen{k0,1}{k1,k2})==0
        t=find(DataGreen{k0,1}{k1,k2}(1,:)>=(Turning(T)+1)*resolutionGreen)   ;
    if  isempty(t)==0
        DataGreen{k0,1}{k1,k2}(2,t)=DataGreen{k0,1}{k1,k2}(2,t)/Ratio         ;
    end
end
end
end
end
end
for T=1:length(Turning)
    Cell1={}    ; Cell2={}  ; Cell3={}       ;
for k0=1:length(DataRed)
for k1=1:size(DataRed{k0,1},1)
for k2=1:size(DataRed{k0,1},2)
if  isempty(DataRed{k0,1}{k1,k2})==0
        t=find(DataRed{k0,1}{k1,k2}(1,:)==(Turning(T)+0)*resolutionRed)       ;
    if  isempty(t)==0
        Cell1{end+1,1}=CellName{k0,1}{k1,k2} ;
    end
        t=find(DataRed{k0,1}{k1,k2}(1,:)==(Turning(T)+1)*resolutionRed)       ;
    if  isempty(t)==0
        Cell2{end+1,1}=CellName{k0,1}{k1,k2} ;
    end
end
end
end
end
for I=1:size(Cell1,1)
for i=1:size(Cell2,1)
if  strcmp(Cell1{I,1},Cell2{i,1})==1
    Cell3{end+1,1}=Cell1{I,1}                ;
end
end
end
    Expression1=[] ; Expression2=[]          ;
for I=1:size(Cell3,1)
for k0=1:length(DataRed)
for k1=1:size(DataRed{k0,1},1)
for k2=1:size(DataRed{k0,1},2)
if  isempty(DataRed{k0,1}{k1,k2})==0 && strcmp(CellName{k0,1}{k1,k2},Cell3{I,1})==1
    t=find(DataRed{k0,1}{k1,k2}(1,:)==(Turning(T)+0)*resolutionRed) ;
    Expression1=[Expression1,DataRed{k0,1}{k1,k2}(2,t)]             ;
    t=find(DataRed{k0,1}{k1,k2}(1,:)==(Turning(T)+1)*resolutionRed) ;
    Expression2=[Expression2,DataRed{k0,1}{k1,k2}(2,t)]             ;
end
end
end
end
end
    Ratio=mean(Expression2)/mean(Expression1) ;
for k0=1:length(DataRed)
for k1=1:size(DataRed{k0,1},1)
for k2=1:size(DataRed{k0,1},2)
if  isempty(DataRed{k0,1}{k1,k2})==0
        t=find(DataRed{k0,1}{k1,k2}(1,:)>=(Turning(T)+1)*resolutionRed) ;
    if  isempty(t)==0
        DataRed{k0,1}{k1,k2}(2,t)=DataRed{k0,1}{k1,k2}(2,t)/Ratio       ;
    end
end
end
end
end
end
    save('Storage\WorkSpace_DataGreen_PLUS','DataGreen','-v7.3')        ;
    save('Storage\WorkSpace_DataRed_PLUS'  ,'DataRed'  ,'-v7.3')        ;
    
    

  % Mission 3 : Normalization B (Expression - Based on Red)

    load('WorkSpace_CellName00000')          ;
    load('Storage\WorkSpace_DataGreen_PLUS') ; load('Storage\WorkSpace_DataRed_PLUS') ; LastGreen=[]   ; LastRed=[]         ; Last=[2,3,1,2,2] ;
for k0=1:5
for k1=1:size(CellName{k0,1},1)
for k2=size(CellName{k0,1},2)-Last(k0)
if  isnumeric(CellName{k0,1}{k1,k2})==0
    LastGreen=[LastGreen,DataGreen{k0,1}{k1,k2}(1,1)]  ;
    LastRed  =[LastRed  ,DataRed{k0,1}{k1,k2}(1,1)  ]  ;
end
end
end
end
    LastGreen=[LastGreen,DataGreen{7,1}{1,2}(1,1),DataGreen{7,1}{2,2}(1,1)] ; LastGreen=max(LastGreen) ; ExpressionGreen=[] ;
    LastRed  =[LastRed  ,DataRed{7,1}{1,2}(1,1)  ,DataRed{7,1}{2,2}(1,1)  ] ; LastRed  =max(LastRed)   ; ExpressionRed  =[] ;
for k0=1:length(DataGreen)
for k1=1:size(DataGreen{k0,1},1)
for k2=1:size(DataGreen{k0,1},2)
if  isempty(DataGreen{k0,1}{k1,k2})==0
        t=find(DataGreen{k0,1}{k1,k2}(1,:)<=LastGreen) ;
    if  isempty(t)==0
        ExpressionGreen=[ExpressionGreen,max(DataGreen{k0,1}{k1,k2}(2,t))]  ;
    end
end
end
end
end
for k0=1:length(DataRed)
for k1=1:size(DataRed{k0,1},1)
for k2=1:size(DataRed{k0,1},2)
if  isempty(DataRed{k0,1}{k1,k2})==0
        t=find(DataRed{k0,1}{k1,k2}(1,:)<=LastRed)     ;
    if  isempty(t)==0
        ExpressionRed=[ExpressionRed,max(DataRed{k0,1}{k1,k2}(2,t))]        ;
    end
end
end
end
end 
        Ratio=max(ExpressionGreen)/max(ExpressionRed)  ;
for k0=1:length(DataGreen)
for k1=1:size(DataGreen{k0,1},1)
for k2=1:size(DataGreen{k0,1},2)
if  isempty(DataGreen{k0,1}{k1,k2})==0
    DataGreen{k0,1}{k1,k2}(2,:)=DataGreen{k0,1}{k1,k2}(2,:)/Ratio           ;
end
end
end
end
    save('Storage\WorkSpace_DataGreen_PLUSPLUS','DataGreen','-v7.3')        ;
    save('Storage\WorkSpace_DataRed_PLUSPLUS'  ,'DataRed'  ,'-v7.3')        ;



  % Mission 4 : Normalization C (Cell Cycle - Based on Red)
  % Global Normalization (AB4-AB256 & MS1-MS32 & E1-E16 & C1-C16 & D1-D8 & P3 & P4)

    load('WorkSpace_CellName00000')       ;
    load('Storage\WorkSpace_DataGreen_PLUSPLUS')      ; load('Storage\WorkSpace_DataRed_PLUSPLUS') ;
    tpGreen=250 ; tpRed=240 ; resolutionGreen=84.5/60 ; resolutionRed=84.5/60 ; % Parameter Setting
    CellCycle=cell(length(CellName)-5,1)  ;
for k0=1
    Cycle=cell(size(CellName{k0,1}))      ;
for k1=1:size(CellName{k0,1},1)
for k2=2:size(CellName{k0,1},2)-1
if  isnumeric(CellName{k0,1}{k1,k2})==0 && isnumeric(CellName{k0,1}{2*k1-1,k2+1})==0 && isnumeric(CellName{k0,1}{2*k1,k2+1})==0
if  isempty(DataGreen{k0,1}{k1,k2})==0  && isempty(DataGreen{k0,1}{2*k1-1,k2+1})==0  && isempty(DataGreen{k0,1}{2*k1,k2+1})==0
    Cycle{k1,k2}=size(DataGreen{k0,1}{k1,k2},2)*resolutionGreen ;
end
end
end
end
    CellCycle{k0,1}=Cycle                 ;
end
for k0=2:5
    Cycle=cell(size(CellName{k0,1}))      ;
for k1=1:size(CellName{k0,1},1)
for k2=1:size(CellName{k0,1},2)-1
if  isnumeric(CellName{k0,1}{k1,k2})==0 && isnumeric(CellName{k0,1}{2*k1-1,k2+1})==0 && isnumeric(CellName{k0,1}{2*k1,k2+1})==0
if  isempty(DataGreen{k0,1}{k1,k2})==0  && isempty(DataGreen{k0,1}{2*k1-1,k2+1})==0  && isempty(DataGreen{k0,1}{2*k1,k2+1})==0
    Cycle{k1,k2}=size(DataGreen{k0,1}{k1,k2},2)*resolutionGreen ;
end
end
end
end
    CellCycle{k0,1}=Cycle                 ;
end
for k0=6:7
    Cycle=cell(size(CellName{k0,1}))      ;
for k1=1
for k2=1
if  isnumeric(CellName{k0,1}{k1,k2})==0 && isnumeric(CellName{7,1}{1,2})==0 && isnumeric(CellName{7,1}{2,2})==0
if  isempty(DataGreen{k0,1}{k1,k2})==0  && isempty(DataGreen{7,1}{1,2})==0  && isempty(DataGreen{7,1}{2,2})==0
    Cycle{k1,k2}=size(DataGreen{k0,1}{k1,k2},2)*resolutionGreen ;
end
end
end
end
    CellCycle{k0,1}=Cycle ;
end
    CycleGreen=CellCycle  ; save('Storage\WorkSpace_CycleGreen','CycleGreen','-v7.3') ;
    
    CellCycle=cell(length(CellName)-5,1)  ;
for k0=1
    Cycle=cell(size(CellName{k0,1}))      ;
for k1=1:size(CellName{k0,1},1)
for k2=2:size(CellName{k0,1},2)-1
if  isnumeric(CellName{k0,1}{k1,k2})==0 && isnumeric(CellName{k0,1}{2*k1-1,k2+1})==0 && isnumeric(CellName{k0,1}{2*k1,k2+1})==0
if  isempty(DataRed{k0,1}{k1,k2})==0    && isempty(DataRed{k0,1}{2*k1-1,k2+1})==0    && isempty(DataRed{k0,1}{2*k1,k2+1})==0
    Cycle{k1,k2}=size(DataRed{k0,1}{k1,k2},2)*resolutionRed     ;
end
end
end
end
    CellCycle{k0,1}=Cycle                 ;
end
for k0=2:5
    Cycle=cell(size(CellName{k0,1}))      ;
for k1=1:size(CellName{k0,1},1)
for k2=1:size(CellName{k0,1},2)-1
if  isnumeric(CellName{k0,1}{k1,k2})==0 && isnumeric(CellName{k0,1}{2*k1-1,k2+1})==0 && isnumeric(CellName{k0,1}{2*k1,k2+1})==0
if  isempty(DataRed{k0,1}{k1,k2})==0    && isempty(DataRed{k0,1}{2*k1-1,k2+1})==0    && isempty(DataRed{k0,1}{2*k1,k2+1})==0
    Cycle{k1,k2}=size(DataRed{k0,1}{k1,k2},2)*resolutionRed     ;
end
end
end
end
    CellCycle{k0,1}=Cycle                 ;
end
for k0=6:7
    Cycle=cell(size(CellName{k0,1}))      ;
for k1=1
for k2=1
if  isnumeric(CellName{k0,1}{k1,k2})==0 && isnumeric(CellName{7,1}{1,2})==0 && isnumeric(CellName{7,1}{2,2})==0
if  isempty(DataRed{k0,1}{k1,k2})==0  && isempty(DataRed{7,1}{1,2})==0  && isempty(DataRed{7,1}{2,2})==0
    Cycle{k1,k2}=size(DataRed{k0,1}{k1,k2},2)*resolutionRed     ;
end
end
end
end
    CellCycle{k0,1}=Cycle ;
end
    CycleRed=CellCycle    ; save('Storage\WorkSpace_CycleRed','CycleRed','-v7.3')       ;
    cycle=[] ; cycle_ave=[]               ;
for k0=1:length(CycleRed)
for k1=1:size(CycleRed{k0,1},1)
for k2=1:size(CycleRed{k0,1},2)
if  isempty(CycleRed{k0,1}{k1,k2})==0 && isempty(CycleGreen{k0,1}{k1,k2})==0
    cycle=[cycle,CycleGreen{k0,1}{k1,k2}] ; cycle_ave=[cycle_ave,CycleRed{k0,1}{k1,k2}] ;
end
end
end
end
    b=sum(cycle.*cycle_ave)/sum(cycle_ave.^2)                                 ;
for k0=1:length(DataGreen)
for k1=1:size(DataGreen{k0,1},1)
for k2=1:size(DataGreen{k0,1},2)
if  isempty(DataGreen{k0,1}{k1,k2})==0
    DataGreen{k0,1}{k1,k2}(1,:)=DataGreen{k0,1}{k1,k2}(1,:)/b                 ;
end
end
end
end
    InitialGreen=min([DataGreen{1,1}{1,1}(1,end),DataGreen{1,1}{2,1}(1,end)]) ;
    InitialRed  =min([DataRed{1,1}{1,1}(1,end)  ,DataRed{1,1}{2,1}(1,end)])   ;
for k0=1:length(DataGreen)
for k1=1:size(DataGreen{k0,1},1)
for k2=1:size(DataGreen{k0,1},2)
if  isempty(DataGreen{k0,1}{k1,k2})==0
    DataGreen{k0,1}{k1,k2}(1,:)=DataGreen{k0,1}{k1,k2}(1,:)-InitialGreen      ;
end
end
end
end
for k0=1:length(DataRed)
for k1=1:size(DataRed{k0,1},1)
for k2=1:size(DataRed{k0,1},2)
if  isempty(DataRed{k0,1}{k1,k2})==0
    DataRed{k0,1}{k1,k2}(1,:)=DataRed{k0,1}{k1,k2}(1,:)-InitialRed            ;
end
end
end
end
    save('Storage\WorkSpace_DataGreen_PLUSPLUSPLUS','DataGreen','-v7.3')      ;
    save('Storage\WorkSpace_DataRed_PLUSPLUSPLUS'  ,'DataRed'  ,'-v7.3')      ;



  % Mission 5 : Normalization D (Cell Cycle - Based on Red)
  % Local Normalization
      
    load('Storage\WorkSpace_DataGreen_PLUSPLUSPLUS') ; load('Storage\WorkSpace_DataRed_PLUSPLUSPLUS') ;
    load('Storage\WorkSpace_CycleGreen')             ; load('Storage\WorkSpace_CycleRed')             ;
for k0=1:length(DataGreen)
for k1=1:size(DataGreen{k0,1},1)
for k2=1:size(DataGreen{k0,1},2)
if  isempty(DataGreen{k0,1}{k1,k2})==0
    T=find(DataGreen{k0,1}{k1,k2}(1,:)<0)            ;
    if  isempty(T)==0
        DataGreen{k0,1}{k1,k2}(:,T)=[]               ;
    end
end
end
end
end
for k0=1:length(DataRed)
for k1=1:size(DataRed{k0,1},1)
for k2=1:size(DataRed{k0,1},2)
if  isempty(DataRed{k0,1}{k1,k2})==0
    T=find(DataRed{k0,1}{k1,k2}(1,:)<0)              ;
    if  isempty(T)==0
        DataRed{k0,1}{k1,k2}(:,T)=[]                 ;
    end
end
end
end
end
    DataGreen{1,1}{2,1}=DataGreen{1,1}{2,1}(:,2)     ; DataGreen{1,1}{2,1}(1,1)=0                     ;
for k0=1:7
for k2=1:size(DataGreen{k0,1},2)
for k1=1:size(DataGreen{k0,1},1)
if  isempty(DataGreen{k0,1}{k1,k2})==0
if  isempty(CycleGreen{k0,1}{k1,k2})==0 && isempty(CycleRed{k0,1}{k1,k2})==0
    TimeG=DataGreen{k0,1}{k1,k2}(1,:)                ; TimeR=DataRed{k0,1}{k1,k2}(1,:)                ;
    DataGreen{k0,1}{k1,k2}(1,:)=(TimeG-TimeG(1))*(TimeR(end)-TimeR(1))/(TimeG(end)-TimeG(1))+TimeR(1) ;
end
if  (isempty(CycleGreen{k0,1}{k1,k2})==1 || isempty(CycleRed{k0,1}{k1,k2})==1) && k2~=1
    delta=DataGreen{k0,1}{ceil(k1/2),k2-1}(1,end)-DataGreen{k0,1}{ceil(k1/2),k2-1}(1,end-1)           ;
    DataGreen{k0,1}{k1,k2}(1,:)=DataGreen{k0,1}{k1,k2}(1,:)-DataGreen{k0,1}{k1,k2}(1,1)+DataGreen{k0,1}{ceil(k1/2),k2-1}(1,end)+delta ;
end 
end
end
end
end
for k0=8:9
for k1=1:size(DataGreen{k0,1},1)
for k2=1:size(DataGreen{k0,1},2)
if  isempty(DataGreen{k0,1}{k1,k2})==0  && isempty(DataRed{k0,1}{k1,k2})==0
    TimeG=DataGreen{k0,1}{k1,k2}(1,:)            ; TimeR=DataRed{k0,1}{k1,k2}(1,:)                    ;
    DataGreen{k0,1}{k1,k2}(1,:)=(TimeG-TimeG(1))*(TimeR(end)-TimeR(1))/(TimeG(end)-TimeG(1))+TimeR(1) ;
end
end
end
end
    save('Storage\WorkSpace_DataGreen_PLUSPLUSPLUSPLUS','DataGreen','-v7.3') ;
    save('Storage\WorkSpace_DataRed_PLUSPLUSPLUSPLUS'  ,'DataRed'  ,'-v7.3') ;



  % Mission 6 : Test

    load('Storage\WorkSpace_DataGreen_PLUSPLUSPLUSPLUS') ; load('Storage\WorkSpace_DataRed_PLUSPLUSPLUSPLUS') ;
    load('WorkSpace_CellName00000')                      ; dataGreen=cell(1,5) ; dataRed=cell(1,5)            ;
    Lineage={'E';'Ea';'Ear';'Earp';'Earpa'}              ; figure ; set(gcf,'position',[200,200,1000,300])    ; set(gcf,'PaperType','a3')    ;
for I=1:length(Lineage)
for k0=1:length(DataGreen)
for k1=1:size(DataGreen{k0,1},1)
for k2=1:size(DataGreen{k0,1},2)
if  isempty(DataGreen{k0,1}{k1,k2})==0 && strcmp(Lineage{I,1},CellName{k0,1}{k1,k2})==1
    plot(DataGreen{k0,1}{k1,k2}(1,:),DataGreen{k0,1}{k1,k2}(2,:),'g-','linewidth',2) ; hold on   ; dataGreen{1,I}=DataGreen{k0,1}{k1,k2} ;
    plot(DataRed{k0,1}{k1,k2}(1,:)  ,DataRed{k0,1}{k1,k2}(2,:)  ,'r-','linewidth',2) ; hold on   ; dataRed{1,I}  =DataRed{k0,1}{k1,k2}   ;
end
end
end
end
end
for I=1:length(Lineage)-1
    plot([dataGreen{1,I}(1,end),dataGreen{1,I+1}(1,1)],[dataGreen{1,I}(2,end),dataGreen{1,I+1}(2,1)],'g-','linewidth',2) ; hold on ;
    plot([dataRed{1,I}(1,end)  ,dataRed{1,I+1}(1,1)]  ,[dataRed{1,I}(2,end)  ,dataRed{1,I+1}(2,1)]  ,'r-','linewidth',2) ; hold on ;
    plot((dataGreen{1,I}(1,end)+dataGreen{1,I+1}(1,1))/2*[1,1],[200,20000],'k--','linewidth',1)  ; hold on        ;
end
    axis([-10,350,0,20000]) ; x=xlabel('\rmDevelopmental Time (min)') ; set(x,'Fontname','arial','Fontsize',17.5) ;
                              y=ylabel('\rmAU')                       ; set(y,'Fontname','arial','Fontsize',17.5) ;
    set(gca,'ytick',[0 5000 10000 15000 20000]    ,'FontSize',17.5,'Fontname','arial') ; clear y ;
    set(gca,'yticklabel',get(gca,'ytick'))    ;
    set(gca,'xtick',[0 50 100 150 200 250 300 350],'FontSize',17.5,'Fontname','arial') ; clear x ;



  % Mission 7 : Data Storage - CD File

    load('WorkSpace_CellName00000')           ;
    load('Storage\WorkSpace_DataGreen_PLUSPLUSPLUSPLUS')                          ;
    tpGreen=250 ; tpRed=240 ; resolutionGreen=84.5/60 ; resolutionRed=84.5/60     ; % Parameter Setting
    Data=importdata('CYB-1_GREEN.csv')                                            ; % Path of CYB-1 File
    N=Data.data ; N=N(:,2)  ; C=Data.textdata ; C=C(2:size(C,1),1) ; NameGreen={} ; NameGreen0={} ; DATA={} ;
for I=1:length(C)
    I/length(C)
if  str2num(C{I,1}(strfind(C{I,1},':')+1:end))<=tpGreen
    NameGreen{end+1,1}=C{I,1}(1:strfind(C{I,1},':')-1)             ;
end
end
for I=1:length(NameGreen)
    I/length(NameGreen)
if  isempty(NameGreen0)==1
    NameGreen0{end+1,1}=NameGreen{I,1} ;
end
if  isempty(NameGreen0)==0
    NUM=0 ;
for J=1:length(NameGreen0)
if  strcmp(NameGreen{I,1},NameGreen0{J,1})==1
    NUM=1 ;
end 
end
if  NUM==0
    NameGreen0{end+1,1}=NameGreen{I,1} ;
end
end
end
for I =1:length(NameGreen0)
    I/length(NameGreen0)
for k0=1:length(CellName)
for k1=1:size(CellName{k0,1},1)
for k2=1:size(CellName{k0,1},2)
if  isnumeric(CellName{k0,1}{k1,k2})==0 && strcmp(NameGreen0{I,1},CellName{k0,1}{k1,k2})==1
    for J=1:size(DataGreen{k0,1}{k1,k2},2)
        DATA{end+1,1}=NameGreen0{I,1}           ; DATA{end,2}=DataGreen{k0,1}{k1,k2}(1,J) ;
        DATA{end,3}=DataGreen{k0,1}{k1,k2}(2,J) ;
    end
end
end
end
end
end
    DATA=cell2table(DATA)   ; writetable(DATA,'Storage\Table S_CYB-1_None.csv')   ;

    load('Storage\WorkSpace_DataRed_PLUSPLUSPLUSPLUS')             ;
    tpGreen=250 ; tpRed=240 ; resolutionGreen=84.5/60 ; resolutionRed=84.5/60     ; % Parameter Setting
    Data=importdata('CDT-1_RED.csv')                                              ; % Path of CYB-1 File
    N=Data.data ; N=N(:,2)  ; C=Data.textdata ; C=C(2:size(C,1),1) ; NameGreen={} ; NameGreen0={} ; DATA={} ;
for I=1:length(C)
    I/length(C)
if  str2num(C{I,1}(strfind(C{I,1},':')+1:end))<=tpRed
    NameRed{end+1,1}=C{I,1}(1:strfind(C{I,1},':')-1)               ;
end
end
for I=1:length(NameRed)
    I/length(NameRed)
if  isempty(NameRed0)==1
    NameRed0{end+1,1}=NameRed{I,1} ;
end
if  isempty(NameRed0)==0
    NUM=0 ;
for J=1:length(NameRed0)
if  strcmp(NameRed{I,1},NameRed0{J,1})==1
    NUM=1 ;
end 
end
if  NUM==0
    NameRed0{end+1,1}=NameRed{I,1} ;
end
end
end
for I =1:length(NameRed0)
    I/length(NameRed0)
for k0=1:length(CellName)
for k1=1:size(CellName{k0,1},1)
for k2=1:size(CellName{k0,1},2)
if  isnumeric(CellName{k0,1}{k1,k2})==0 && strcmp(NameRed0{I,1},CellName{k0,1}{k1,k2})==1
    for J=1:size(DataRed{k0,1}{k1,k2},2)
        DATA{end+1,1}=NameRed0{I,1}           ; DATA{end,2}=DataRed{k0,1}{k1,k2}(1,J) ;
        DATA{end,3}=DataRed{k0,1}{k1,k2}(2,J) ;
    end
end
end
end
end
end
    DATA=cell2table(DATA)   ; writetable(DATA,'Storage\Table S_CDT-1_None.csv')       ;