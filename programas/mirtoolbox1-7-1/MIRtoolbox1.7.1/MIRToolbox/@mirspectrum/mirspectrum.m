function varargout = mirspectrum(orig,varargin)
%   s = mirspectrum(x) computes the spectrum of the audio signal x, showing
%       the distribution of the energy along the frequencies.
%       (x can be the name of an audio file as well.)
%   Optional argument:
%       mirspectrum(...,'Frame',l,h) computes spectrogram, using frames of
%           length l seconds and a hop rate h.
%           Default values: l = .05 s, h = .5.
%       mirspectrum(...,'Min',mi) indicates the lowest frequency taken into
%           consideration, expressed in Hz.
%           Default value: 0 Hz.
%       mirspectrum(...,'Max',ma) indicates the highest frequency taken into
%           consideration, expressed in Hz.
%           Default value: the maximal possible frequency, corresponding to
%           the sampling rate of x divided by 2.
%       mirspectrum(...,'Window',w): windowing method:
%           either w = 0 (no windowing) or any windowing function proposed
%               in the Signal Processing Toolbox (help window).
%           default value: w = 'hamming'
%
%       mirspectrum(...,'Cents'): decomposes the energy in cents.
%       mirspectrum(...,'Collapsed'): collapses the spectrum into one
%           octave divided into 1200 cents.
%       Redistribution of the frequencies into bands:
%           mirspectrum(...,'Mel'): Mel bands.
%               (Requires the Auditory Toolbox.)
%           mirspectrum(...,'Bark'): Bark bands.
%               (Code based on Pampalk's MA toolbox).
%           If the audio signal was frame decomposed, the output s is a
%               band-decomposed spectrogram. It is then possible to compute
%               the spectrum of the temporal signal in each band,
%               using the following syntax:
%                   mirspectrum(s,'AlongBands')
%               This corresponds to fluctuation (cf. mirfluctuation).
%           mirspectrum(...,'Mask'): Models masking phenomena in each band.
%               (Code based on Pampalk's MA toolbox).
%       mirspectrum(...,'Normal'): normalizes with respect to energy.
%       mirspectrum(...,'NormalLength'): normalizes with respect to input length.
%       mirspectrum(...,'NormalInput'): input signal is normalized from 0 to 1.
%       mirspectrum(...,'Power'): squares the energy.
%       mirspectrum(...,'dB'): represents the spectrum energy in decibel scale.
%       mirspectrum(...,'dB',th): keeps only the highest energy over a
%           range of th dB.
%       mirspectrum(...,'Terhardt'): modulates the energy following
%           (Terhardt, 1979) outer ear model. (Code based on Pampalk's MA
%           toolbox).
%       mirspectrum(...,'Resonance',r): multiplies the spectrum with a 
%           resonance curve. Possible value for r:
%               'ToiviainenSnyder': highlights best perceived meter 
%                       (Toiviainen & Snyder 2003)
%                   (default value for spectrum of envelopes)
%               'Fluctuation': fluctuation strength (Fastl 1982)
%                   (default value for spectrum of band channels)
%       mirspectrum(...,'Prod',m): Enhances components that have harmonics
%           located at multiples of range(s) m of the signal's fundamental 
%           frequency. Computed by compressing the signal by the list of
%           factors m, and by multiplying all the results with the original 
%           signa (Alonso et al, 2003).
%       mirspectrum(...,'Sum',s): Similar option using summation instead of
%           product.
%
%       mirspectrum(...,'MinRes',mr): Indicates a minimal accepted
%           frequency resolution, in Hz. The audio signal is zero-padded in
%           order to reach the desired resolution.
%           If the 'Mel' option is toggled on, 'MinRes' is set by default
%               to 66 Hz.
%       mirspectrum(...,'MinRes',mr,'OctaveRatio',tol): Indicates the
%           minimal accepted resolution in terms of number of divisions of 
%           the octave. Low  frequencies are ignored in order to reach the
%           desired resolution.
%               The corresponding required frequency resolution is equal to
%               the difference between the first frequency bins, multiplied
%               by the constraining multiplicative factor tol (set by
%               default to .75).
%       mirspectrum(...,'Res',r): Indicates the required precise frequency
%           resolution, in Hz. The audio signal is zero-padded in order to
%           reach the desired resolution.
%       mirspectrum(...,'Length',l): Specifies the length of the FFT,
%           overriding the FFT length initially planned.
%       mirspectrum(...,'ZeroPad',s): Zero-padding of s samples.
%       mirspectrum(...,'WarningRes',s): Indicates a required frequency
%           resolution, in Hz, for the input signal. If the resolution does
%           not reach that prerequisite, a warning is displayed.
%       mirspectrum(...,'ConstantQ',nb): Carries out a Constant Q Transform
%           instead of a FFT, with a number of bins per octave fixed to nb.
%           Default value for nb: 12 bins per octave.
%
%       mirspectrum(...,'Smooth',o): smooths the envelope using a moving
%           average of order o.
%           Default value when the option is toggled on: o=10
%       mirspectrum(...,'Gauss',o): smooths the envelope using a gaussian
%           of standard deviation o samples.
%           Default value when the option is toggled on: o=10
%       mirspectrum(...,'TimeSmooth',o): smooths each frequency channel of
%           a spectrogram using a moving average of order o.
%           Default value when the option is toggled on: o=10
%       mirspectrum(...,'Phase',0): do not compute the FFT phase.
    
        win.key = 'Window';
        win.type = 'String';
        win.default = 'hamming';
    option.win = win;
    
        min.key = 'Min';
        min.type = 'Integer';
        min.default = 0;
    option.min = min;
    
        max.key = 'Max';
        max.type = 'Integer';
        max.default = Inf;
    option.max = max;
    
        mr.key = 'MinRes';
        mr.type = 'Integer';
        mr.default = 0;
    option.mr = mr;

        res.key = 'Res';
        res.type = 'Integer';
        res.default = NaN;
    option.res = res;

        length.key = 'Length';
        length.type = 'Integer';
        length.default = NaN;
    option.length = length;
    
        zp.key = 'ZeroPad';
        zp.type = 'Integer';
        zp.default = 0;
        zp.keydefault = Inf;
    option.zp = zp;
    
        wr.key = 'WarningRes';
        wr.type = 'Integer';
        wr.default = 0;
    option.wr = wr;
    
        octave.key = 'OctaveRatio';
        octave.type = 'Boolean';
        octave.default = 0;
    option.octave = octave;
    
        constq.key = 'ConstantQ';
        constq.type = 'Integer';
        constq.default = 0;
        constq.keydefault = 12;
    option.constq = constq;
    
        alongbands.key = 'AlongBands';
        alongbands.type = 'Boolean';
        alongbands.default = 0;
    option.alongbands = alongbands;

        ni.key = 'NormalInput';
        ni.type = 'Boolean';
        ni.default = 0;
    option.ni = ni;
    
        nl.key = 'NormalLength';
        nl.type = 'Boolean';
        nl.default = 0;
        nl.when = 'After';
    option.nl = nl;
    
        norm.key = 'Normal';
        norm.type = 'Integer';
        norm.default = 0;
        norm.keydefault = 1;
        norm.when = 'After';
    option.norm = norm;
    
        band.type = 'String';
        band.choice = {'Freq','Mel','Bark','Cents'};
        band.default = 'Freq';
        band.when = 'Both';
    option.band = band;

        nbbands.key = 'Bands';
        nbbands.type = 'Integer';
        nbbands.default = 0;
        nbbands.when = 'After';
    option.nbbands = nbbands;

        mprod.key = 'Prod';
        mprod.type = 'Integers';
        mprod.default = [];
        mprod.keydefault = 2:6;
        mprod.when = 'After';
    option.mprod = mprod;

        msum.key = 'Sum';
        msum.type = 'Integers';
        msum.default = [];
        msum.keydefault = 2:6;
        msum.when = 'After';
    option.msum = msum;

        reso.key = 'Resonance';
        reso.type = 'String';
        reso.choice = {'ToiviainenSnyder','Fluctuation','Meter',0,'no','off'};
        reso.default = 0;
        reso.keydefault = 1;
        reso.when = 'After';
    option.reso = reso;
    
        log.key = 'log';
        log.type = 'Boolean';
        log.default = 0;
        log.when = 'After';
    option.log = log;

        db.key = 'dB';
        db.type = 'Integer';
        db.default = 0;
        db.keydefault = Inf;
        db.when = 'After';
    option.db = db;
    
        pow.key = 'Power';
        pow.type = 'Boolean';
        pow.default = 0;
        pow.when = 'After';
    option.pow = pow;

        terhardt.key = 'Terhardt';
        terhardt.type = 'Boolean';
        terhardt.default = 0;
        terhardt.when = 'After';
    option.terhardt = terhardt;

        mask.key = 'Mask';
        mask.type = 'Boolean';
        mask.default = 0;
        mask.when = 'After';
    option.mask = mask;

    %    e.key = 'Enhanced';
    %    e.type = 'Integer';
    %    e.default = [];
    %    e.keydefault = 2:10;
    %    e.when = 'After';
    %option.e = e;

        collapsed.key = 'Collapsed';
        collapsed.type = 'Boolean';
        collapsed.default = 0;
        collapsed.when = 'Both';
    option.collapsed = collapsed;
    
        aver.key = 'Smooth';
        aver.type = 'Integer';
        aver.default = 0;
        aver.keydefault = 10;
        aver.when = 'After';
    option.aver = aver;
    
        gauss.key = 'Gauss';
        gauss.type = 'Integer';
        gauss.default = 0;
        gauss.keydefault = 10;
        gauss.when = 'After';
    option.gauss = gauss;

        timesmooth.key = 'TimeSmooth';
        timesmooth.type = 'Integer';
        timesmooth.default = 0;
        timesmooth.keydefault = 10;
        timesmooth.when = 'After';
    option.timesmooth = timesmooth;
    
        diff.key = 'Diff';
        diff.type = 'Integer';
        diff.default = 0;
        diff.keydefault = 10;
        diff.when = 'After';
    option.diff = diff;
    
        phase.key = 'Phase';
        phase.type = 'Boolean';
        phase.default = 1;
    option.phase = phase;

specif.option = option;

specif.defaultframelength = 0.05;
specif.defaultframehop = 0.5;

specif.eachchunk = @eachchunk;
specif.combinechunk = @combinechunk;

if isamir(orig,'mirscalar') || isamir(orig,'mirenvelope')
    specif.nochunk = 1;
end

varargout = mirfunction(@mirspectrum,orig,varargin,nargout,specif,@init,@main);


function [x type] = init(x,option)
type = 'mirspectrum';


function s = main(orig,option,postoption)
if isstruct(option)
    if option.collapsed
        option.band = 'Cents';
    end
    if isnan(option.res) && strcmpi(option.band,'Cents') && option.min
        option.res = option.min *(2^(1/1200)-1)*.9;
    end    
end
if not(isempty(postoption))
    if not(strcmpi(postoption.band,'Freq') && isempty(postoption.msum) ...
            && isempty(postoption.mprod)) ...
            || postoption.log || postoption.db ...
            || postoption.pow || postoption.mask || postoption.collapsed ...
            || postoption.aver || postoption.gauss
        option.phase = 0;
    end
end
if iscell(orig)
    orig = orig{1};
end
if isa(orig,'mirspectrum') && ...
        not(isfield(option,'alongbands') && option.alongbands)
    s = orig;
    if isfield(option,'min') && ...
            (option.min || iscell(option.max) || option.max < Inf)
        magn = get(s,'Magnitude');
        freq = get(s,'Frequency');
        for k = 1:length(magn)
            m = magn{k};
            f = freq{k};
            if iscell(option.max)
                mi = option.min{k};
                ma = option.max{k};
            else
                mi = option.min;
                ma = option.max;
            end
            if not(iscell(m))
                m = {m};
                f = {f};
            end
            for l = 1:length(m)
                range = find(and(f{l}(:,1) >= mi,f{l}(:,1) <= ma));
                m{l} = m{l}(range,:,:);
                f{l} = f{l}(range,:,:);
            end
            magn{k} = m;
            freq{k} = f;
        end
        s = set(s,'Magnitude',magn,'Frequency',freq);
    end
    if not(isempty(postoption)) && not(isequal(postoption,0))
        s = post(s,postoption);
    end
elseif ischar(orig)
    s = mirspectrum(miraudio(orig),option,postoption);
else
    if nargin == 0
        orig = [];
    end
    s.phase = [];
    s.log = 0;
    s.xscale = 'Freq';
    s.pow = 1;
    s = class(s,'mirspectrum',mirdata(orig));
    s = purgedata(s);
    s = set(s,'Title','Spectrum','Abs','frequency (Hz)','Ord','magnitude');
    %disp('Computing spectrum...')
    sig = get(orig,'Data');
    t = get(orig,'Pos');
    if isempty(t)
        t = get(orig,'FramePos');
        for k = 1:length(sig)
            for l = 1:length(sig{k})
                sig{k}{l} = sig{k}{l}';
                t{k}{l} = t{k}{l}(1,:,:)';
            end
        end
    end
    fs = get(orig,'Sampling');
    fp = get(orig,'FramePos');
    fr = get(orig,'FrameRate');
    lg = get(orig,'Length');
    m = cell(1,length(sig));
    p = cell(1,length(sig));
    f = cell(1,length(sig));
    for i = 1:length(sig)
        d = sig{i};
        fpi = fp{i};
        if not(iscell(d))
            d = {d};
        end
        if option.alongbands
            fsi = fr{i};
        else
            fsi = fs{i};
        end
        mi = cell(1,length(d));
        phi = cell(1,length(d));
        fi = cell(1,length(d));
        for J = 1:length(d)
            dj = d{J};
            if option.ni
                mxdj = repmat(max(dj),[size(dj,1),1,1]);
                mndj = repmat(min(dj),[size(dj,1),1,1]);
                dj = (dj-mndj)./(mxdj-mndj);
            end
            if option.alongbands
                if size(dj,1)>1
                    error('ERROR IN MIRSPECTRUM: ''AlongBands'' is restricted to spectrum decomposed into bands, such as ''Mel'' and ''Bark''.') 
                end
                dj = reshape(dj,[size(dj,2),1,size(dj,3)]);
                fp{i}{J} = fp{i}{J}([1;end]);
                lg{i}{J} = diff(fp{i}{J}) * fs{i};
            end
                        
            if option.constq
                % Constant Q Transform
                r = 2^(1/option.constq);
                Q = 1 / (r - 1);
                f_max = min(fsi/2,option.max);
                f_min = option.min;
                if not(f_min)
                    f_min = 16.3516;
                end
                B = floor(log(f_max/f_min) / log(r)); % number of bins
                N0 = round(Q*fsi/f_min); % maximum Nkcq
                j2piQn = -1i*2*pi*Q*(0:N0-1)';

                fj = f_min * r.^(0:B-1)';
                transf = NaN(B,size(dj,2),size(dj,3));
                for kcq = 1:B
                    Nkcq = round(Q*fsi/fj(kcq));
                    win = mirwindow(dj,option.win,Nkcq);
                    exq = repmat(exp(j2piQn(1:Nkcq)/Nkcq),...
                                 [1,size(win,2),size(win,3)]);
                    transf(kcq,:) = sum(win.* exq) / Nkcq;
                end
            else
                % FFT
                dj = mirwindow(dj,option.win);
                if option.zp
                    if option.zp < Inf
                        dj = [dj;zeros(option.zp,size(dj,2),size(dj,3))];
                    else
                        dj = [dj;zeros(size(dj))];
                    end
                end
                if isstruct(postoption)
                    if strcmpi(postoption.band,'Mel') && ...
                            (not(option.mr) || option.mr > 66)
                        option.mr = 66;
                    end
                else
                    %warning('WARNING in MIRSPECTRUM (for debugging purposes): By default, minimum resolution specified.')
                    if not(option.mr)
                        option.mr = 66;
                    end
                end
                if option.octave
                    N = size(dj,1);
                    res = (2.^(1/option.mr)-1)*option.octave;
                        % Minimal freq ratio between 2 first bins.
                        % freq resolution should be > option.min * res
                    Nrec = fsi/(option.min*res);
                        % Recommended minimal sample length.
                    if Nrec > N
                            % If actual sample length is too small.
                        option.min = fsi/N / res;
                        warning('WARNING IN MIRSPECTRUM: The input signal is too short to obtain the desired octave resolution. Lowest frequencies will be ignored.');
                        display(['(The recommended minimal input signal length would be ' num2str(Nrec/fsi) ' s.)']);
                        display(['New low frequency range: ' num2str(option.min) ' Hz.']);
                    end
                    N = 2^nextpow2(N);
                elseif isnan(option.length)
                    if isnan(option.res)
                        N = size(dj,1);
                        if option.mr && N < fsi/option.mr
                            if option.wr && N < fsi/option.wr
                                warning('WARNING IN MIRSPECTRUM: The input signal is too short to obtain the desired frequency resolution. Performed zero-padding will not guarantee the quality of the results.'); 
                            end                
                            N = max(N,fsi/option.mr);
                        end
                        N = 2^nextpow2(N);
                    else
                        N = ceil(fsi/option.res);
                    end
                else
                    N = option.length;
                end

                % Here is the spectrum computation itself
                transf = fft(dj,N); %/(length(dj));

                len = floor(N/2+1);
                fj = fsi/2 * linspace(0,1,len)';
                if option.max
                    maxf = find(fj>=option.max,1);
                    if isempty(maxf)
                        maxf = len;
                    end
                else
                    maxf = len;
                end
                if option.min
                    minf = find(fj>=option.min,1);
                    if isempty(minf)
                        maxf = len;
                    end
                else
                    minf = 1;
                end
                
                transf = transf(minf:maxf,:,:);
                fj = fj(minf:maxf);
            end
            
            mi{J} = abs(transf);
            if option.phase
                phi{J} = angle(transf);
            end
            fi{J} = repmat(fj,[1,size(transf,2),size(transf,3)]);
        end
        if iscell(sig{i})
            m{i} = mi;
            p{i} = phi;
            f{i} = fi;
        else
            m{i} = mi{1};
            p{i} = phi{1};
            f{i} = fi{1};
        end
    end
    s = set(s,'Frequency',f,'Magnitude',m,'Phase',p,...
              'FramePos',fp,'Length',lg);
    if not(isempty(postoption)) && isstruct(postoption)
        s = post(s,postoption,orig);
    end
end

   
function s = post(s,option,orig)
if option.collapsed
    option.band = 'Cents';
end
m = get(s,'Magnitude');
f = get(s,'Frequency');
sr = get(s,'Sampling');
for k = 1:length(m)
    if not(iscell(m{k}))
        m{k} = {m{k}};
        f{k} = {f{k}};
    end
end
if option.timesmooth
    [state s] = gettmp(s);
    B = ones(1,option.timesmooth)/option.timesmooth;
    for h = 1:length(m)
        for l = 1:length(m{h})
            [m{h}{l} state] = filter(B,1,m{h}{l},state,2);
            %mhl = m{h}{l};
            %for i = 1:size(m{h}{l},2)
            %    m{h}{l}(:,i) = min(mhl(:,max(1,i-option.timesmooth+1):i),...
            %                       [],2);
            %end
        end
    end
    s = settmp(s,state);
end
if option.diff
    for h = 1:length(m)
        for l = 1:length(m{h})
            m{h}{l} = [zeros(size(m{h}{l},1),option.diff),...
                       max(0,m{h}{l}(:,1+option.diff:end) - ...
                             m{h}{l}(:,1:end-option.diff))];
        end
    end
end
if get(s,'Power') == 1 && ...
        (option.pow || any(option.mprod) || any(option.msum)) 
                % mprod could be tried without power?
    for h = 1:length(m)
        for l = 1:length(m{k})
            m{h}{l} = m{h}{l}.^2;
        end
    end
    s = set(s,'Power',2,'Title',['Power ',get(s,'Title')],'Phase',[]);
end
if any(option.mprod)
    for h = 1:length(m)
        for l = 1:length(m{h})
            z0 = m{h}{l};
            z1 = z0;
            for k = 1:length(option.mprod)
                mpr = option.mprod(k);
                if mpr
                    zi = ones(size(z0));
                    zi(1:floor(end/mpr),:,:) = z0(mpr:mpr:end,:,:);
                    z1 = z1.*zi;
                end
            end
            m{h}{l} = z1;
        end
    end
    s = set(s,'Title','Spectral product');
end
if any(option.msum)
    for h = 1:length(m)
        for l = 1:length(m{h})
            z0 = m{h}{l};
            z1 = z0;
            for k = 1:length(option.msum)
                mpr = option.msum(k);
                if mpr
                    zi = ones(size(z0));
                    zi(1:floor(end/mpr),:,:) = z0(mpr:mpr:end,:,:);
                    z1 = z1+zi;
                end
            end
            m{h}{l} = z1;
        end
    end
    s = set(s,'Title','Spectral sum');
end
if option.norm
    for k = 1:length(m)
        for l = 1:length(m{k})
            mkl = m{k}{l};
            nkl = zeros(1,size(mkl,2),size(mkl,3));
            for kk = 1:size(mkl,2)
                for ll = 1:size(mkl,3)
                    nkl(1,kk,l) = norm(mkl(:,kk,ll));
                end
            end
            m{k}{l} = mkl./repmat(nkl,[size(m{k}{k},1),1,1]);
        end
    end
end
if option.nl
    lg = get(s,'Length');
    for k = 1:length(m)
        for l = 1:length(m{k})
            m{k}{l} = m{k}{l}/(lg{k}{l}/sr{k});
        end
    end
end
if option.terhardt && not(isempty(find(f{1}{1}))) % This excludes the case where spectrum already along bands
    % Code taken from Pampalk's MA Toolbox
    for k = 1:length(m)
        for l = 1:length(m{k})
            W_Adb = zeros(size(f{k}{l}));
            W_Adb(2:size(f{k}{l},1),:,:) = ...
                + 10.^((-3.64*(f{k}{l}(2:end,:,:)/1000).^-0.8 ...
                + 6.5 * exp(-0.6 * (f{k}{l}(2:end,:,:)/1000 - 3.3).^2) ...
                - 0.001*(f{k}{l}(2:end,:,:)/1000).^4)/20);
            W_Adb = W_Adb.^2;
            m{k}{l} = m{k}{l}.*W_Adb;
        end
    end
end
if option.reso
    if not(ischar(option.reso))
        if strcmp(get(s,'XScale'),'Mel')
            option.reso = 'Fluctuation';
        else
            option.reso = 'ToiviainenSnyder';
        end
    end
    for k = 1:length(m)
        for l = 1:length(m{k})
            if strcmpi(option.reso,'ToiviainenSnyder') || strcmpi(option.reso,'Meter')
                w = max(0,...
                    1 - 0.25*(log2(max(1./max(f{k}{l},1e-12),1e-12)/0.5)).^2);
            elseif strcmpi(option.reso,'Fluctuation')
                w1 = f{k}{l} / 4; % ascending part of the fluctuation curve;
                w2 = 1 - 0.3 * (f{k}{l} - 4)/6; % descending part; %%% Negative!
                w = min(w1,w2);
                w = max(0,w);
            end
            if max(w) == 0
                warning('The resonance curve, not defined for this range of delays, will not be applied.')
            else
                m{k}{l} = m{k}{l}.* w;
            end
        end
    end
end
if strcmp(s.xscale,'Freq')
    if strcmpi(option.band,'Mel') 
        % The following is largely based on the source code from Auditory Toolbox 
        % (A part that I could not call directly from MIRtoolbox)

        % (Malcolm Slaney, August 1993, (c) 1998 Interval Research Corporation)

        try
            MakeERBFilters(1,1,1); % Just to be sure that the Auditory Toolbox is installed
        catch
            error('ERROR IN MIRFILTERBANK: Auditory Toolbox needs to be installed.');
        end  

        %disp('Computing Mel-frequency spectral representation...')
        lowestFrequency = 133.3333;
        if not(option.nbbands)
            option.nbbands = 40;
        end
        linearFilters = min(13,option.nbbands);
        linearSpacing = 66.66666666;
        logFilters = option.nbbands - linearFilters;
        logSpacing = 1.0711703;
        totalFilters = option.nbbands;

        % Figure the band edges.  Interesting frequencies are spaced
        % by linearSpacing for a while, then go logarithmic.  First figure
        % all the interesting frequencies.  Lower, center, and upper band
        % edges are all consequtive interesting frequencies. 
        freqs = lowestFrequency + (0:linearFilters-1)*linearSpacing;
        freqs(linearFilters+1:totalFilters+2) = ...
                      freqs(linearFilters) * logSpacing.^(1:logFilters+2);
        lower = freqs(1:totalFilters);
        center = freqs(2:totalFilters+1);
        upper = freqs(3:totalFilters+2);
        
        % Figure out the height of the triangle so that each filter has 
        % unit weight, assuming a triangular weighting function.
        triangleHeight = 2./(upper-lower);

        e = cell(1,length(m));
        nch = cell(1,length(m));
        for h = 1:length(m)
            e{h} = cell(1,length(m{h}));
            for i = 1:length(m{h})
                mi = m{h}{i};
                fi = f{h}{i}(:,1,1);
                fftSize = size(fi,1);
                
                % We now want to combine FFT bins and figure out 
                % each frequencies contribution
                mfccFilterWeights = zeros(totalFilters,fftSize);
                for chan=1:totalFilters
                     mfccFilterWeights(chan,:) = triangleHeight(chan).*...
                        ((fi > lower(chan) & fi <= center(chan)).* ...
                         (fi-lower(chan))/(center(chan)-lower(chan)) + ...
                         (fi > center(chan) & fi < upper(chan)).* ...
                         (upper(chan)-fi)/(upper(chan)-center(chan)));
                end
                if find(diff(not(sum(mfccFilterWeights,2)))==-1)
                    % If one channel has no weight whereas the higher one
                    % has a positive weight.
                    warning('WARNING in MIRSPECTRUM: The frequency resolution of the spectrum is too low for the Mel transformation. Some Mel components are undefined.')
                    display('Recommended frequency resolution: at least 66 Hz.')
                end
                e{h}{i} = zeros(1,size(mi,2),totalFilters);
                for J = 1:size(mi,2)
                    if max(mi(:,J)) > 0
                        fftData = zeros(fftSize,1); % Zero-padding ?
                        fftData(1:size(mi,1)) = mi(:,J);
                        p = mfccFilterWeights * fftData + 1e-16;
                        e{h}{i}(1,J,:) = reshape(p,[1,1,length(p)]);
                    end
                end
                f{h}{i} = zeros(1,size(mi,2),totalFilters);
            end
            nch{h} = (1:totalFilters)';
        end
        m = e;
        s = set(s,'XScale','Mel','Title','Mel-Spectrum',...
                  'Abs','Mel bands','Channels',nch,'Phase',[]);
    elseif strcmpi(option.band,'Bark')
        sr = get(s,'Sampling');
        % Code taken from Pampalk's MA Toolbox.
        %% zwicker & fastl: psychoacoustics 1999, page 159
        bark_upper = [10 20 30 40 51 63 77 92 108 127 148 172 200 232 270 315 370 440 530 640 770 950 1200 1550]*10; %% Hz
        e = cell(1,length(m));
        nch = cell(1,length(m));
        for h = 1:length(m)
            %% ignore critical bands outside of sampling rate range
            cb = min(min([find(bark_upper>sr{h}/2),length(bark_upper)]),length(bark_upper));
            e{h} = cell(1,length(m{h}));
            for i = 1:length(m{h})
                mi = sum(m{h}{i},3);
                e{h}{i} = zeros(1,size(mi,2),cb);
                k = 1;
                for J=1:cb, %% group into bark bands
                    idx = find(f{h}{i}(k:end,1,1)<=bark_upper(J));
                    idx = idx + k-1;
                    e{h}{i}(1,:,J) = sum(mi(idx,:,:),1);
                    k = max(idx)+1;
                end
                f{h}{i} = zeros(1,size(mi,2),cb);
            end
            nch{h} = (1:cb)';
           end
        m = e;
        s = set(s,'XScale','Bark','Title','Bark-Spectrum',...
                  'Abs','Bark bands','Channels',nch,'Phase',[]);
    elseif strcmpi(option.band,'Cents') || option.collapsed
        for h = 1:length(m)
            for i = 1:length(m{h})
                mi = m{h}{i};
                fi = f{h}{i};
                isgood = fi(:,1,1)*(2^(1/1200)-1) >= fi(2,1,1)-fi(1,1,1);
                good = find(isgood);
                if isempty(good)
                    mirerror('mirspectrum',...
                        'The frequency resolution of the spectrum is too low to be decomposed into cents.');
                    display('Hint: if you specify a minimum value for the frequency range (''Min'' option)');
                    display('      and if you do not specify any frequency resolution (''Res'' option), ');
                    display('      the correct frequency resolution will be automatically chosen.');
                end
                if good>1
                    warning(['MIRSPECTRUM: Frequency resolution in cent is achieved for frequencies over ',...
                        num2str(floor(fi(good(1)))),' Hz. Lower frequencies are ignored.'])
                    display('Hint: if you specify a minimum value for the frequency range (''Min'' option)');
                    display('      and if you do not specify any frequency resolution (''Res'' option), ');
                    display('      the correct frequency resolution will be automatically chosen.');
                end
                fi = fi(good,:,:);
                mi = mi(good,:,:);
                f2cents = 440*2.^(1/1200*(-1200*10:1200*10-1)');
                    % The frequencies corresponding to the cent range
                cents = repmat((0:1199)',[20,size(fi,2),size(fi,3)]);
                    % The cent range is for the moment centered to A440
                octaves = ones(1200,1)*(-10:10);
                octaves = repmat(octaves(:),[1,size(fi,2),size(fi,3)]);
                select = find(f2cents>fi(1) & f2cents<fi(end));
                    % Cent range actually used in the current spectrum
                f2cents = repmat(f2cents(select),[1,size(fi,2),size(fi,3)]);
                cents = repmat(cents(select),[1,size(fi,2),size(fi,3)]);
                octaves = repmat(octaves(select),[1,size(fi,2),size(fi,3)]);
                m{h}{i} = interp1(fi(:,1,1),mi,f2cents(:,1,1));
                f{h}{i} = octaves*1200+cents + 6900;
                    % Now the cent range is expressed in midicent
            end
        end
        s = set(s,'Abs','pitch (in midicents)','XScale','Cents','Phase',[]);
    end
end
if option.mask
    if strcmp(s.xscale,'Freq')
        warning('WARNING IN MIRSPECTRUM: ''Mask'' option available only for Mel-spectrum and Bark-spectrum.');
        disp('''Mask'' option ignored');
    else
        nch = get(s,'Channels');
        for h = 1:length(m)
            % Code taken from Pampalk's MA Toolbox.
            %% spreading function: schroeder et al., 1979, JASA, optimizing
            %% digital speech coders by exploiting masking properties of the human ear
            cb = length(nch{h});  % Number of bands.
            for i = 1:cb, 
                spread(i,:) = 10.^((15.81+7.5*((i-(1:cb))+0.474)-17.5*(1+((i-(1:cb))+0.474).^2).^0.5)/10);
            end
            for i = 1:length(m{h})
                for J = 1:size(m{h}{i},2)
                    mj = m{h}{i}(1,J,:);
                    mj = spread(1:length(mj),1:length(mj))*mj(:);
                    m{h}{i}(1,J,:) = reshape(mj,1,1,length(mj));
                end
            end
        end
    end
end
if option.collapsed
    for h = 1:length(m)
        for i = 1:length(m{h})
            mi = m{h}{i};
            fi = f{h}{i};
            centclass = rem(fi(:,1,1),1200);
            %neg = find(centclass<0);
            %centclass(neg) = 1200 + centclass(neg);
            m{h}{i} = NaN(1200,size(mi,2),size(mi,3));
            for k = 0:1199
                m{h}{i}(k+1,:,:) = sum(mi(find(centclass==k),:,:),1);
            end
            f{h}{i} = repmat((0:1199)',[1,size(fi,2),size(fi,3)]);
        end
    end
    s = set(s,'Abs','Cents','XScale','Cents(Collapsed)');
end
if option.log || option.db
    if not(isa(s,'mirspectrum') && s.log)
        for k = 1:length(m)
            if not(iscell(m{k}))
                m{k} = {m{k}};
                f{k} = {f{k}};
            end
            for l = 1:length(m{k})
                m{k}{l} = log10(m{k}{l}+1e-16);
                if option.db
                    m{k}{l} = 10*m{k}{l};
                    if get(s,'Power') == 1
                        m{k}{l} = m{k}{l}*2;
                    end
                end
            end
        end
    elseif isa(s,'mirspectrum') && option.db && s.log<10
        for k = 1:length(m)
            for l = 1:length(m{k})
                m{k}{l} = 10*m{k}{l};
                if get(s,'Power') == 1
                    m{k}{l} = m{k}{l}*2;
                end
            end
        end
    end
    if option.db
        s = set(s,'log',10);
        s = set(s,'Power',2);
    else
        s = set(s,'log',1);
    end
    if option.db>0 && option.db < Inf
        for k = 1:length(m)
            for l = 1:length(m{k})
                m{k}{l} = m{k}{l}-repmat(max(m{k}{l}),[size(m{k}{l},1) 1 1]);
                m{k}{l} = option.db + max(-option.db,m{k}{l});
            end
        end
    end
    s = set(s,'Phase',[]);
end
if option.aver
    for k = 1:length(m)
        for i = 1:length(m{k})
            m{k}{i} = filter(ones(1,option.aver)/option.aver,1,m{k}{i});
        end
    end
    s = set(s,'Phase',[]);
end
if option.gauss
    for k = 1:length(m)
        for i = 1:length(m{k})
            sigma = option.gauss;
            gauss = 1/sigma/2/pi...
                    *exp(- (-4*sigma:4*sigma).^2 /2/sigma^2);
            y = filter(gauss,1,[m{k}{i};zeros(4*sigma,size(m{k}{1},2))]);
            y = y(4*sigma:end,:,:);
            m{k}{i} = y(1:size(m{k}{i},1),:,:);
        end
    end
    s = set(s,'Phase',[]);
end
s = set(s,'Magnitude',m,'Frequency',f);


function dj = mirwindow(dj,win,N)
if nargin<3
    N = size(dj,1);
elseif size(dj,1)<N
    dj(N,1,1) = 0;
end
if not(win == 0)
    winf = str2func(win);
    try
        w = window(winf,N);
    catch
        if strcmpi(win,'hamming')
            disp('Signal Processing Toolbox does not seem to be installed. Recompute the hamming window manually.');
            w = 0.54 - 0.46 * cos(2*pi*(0:N-1)'/(N-1));
        else
            warning(['WARNING in MIRSPECTRUM: Unknown windowing function ',win,' (maybe Signal Processing Toolbox is not installed).']);
            return
        end
    end
    kw = repmat(w,[1,size(dj,2),size(dj,3)]);
    dj = dj(1:N,:,:).* kw;
end


function [y orig] = eachchunk(orig,option,missing,postchunk)
option.zp = option.zp+missing;
y = mirspectrum(orig,option);


function y = combinechunk(old,new)
do = get(old,'Data');
do = do{1}{1};
dn = get(new,'Data');
dn = dn{1}{1};
y = set(old,'ChunkData',do+dn);