import { Routes } from '@angular/router';
import { BodyComponent } from './inicio/body/body.component';
import { IndexComponent as IndexFicha } from './ficha/index/index.component';
import { CreateComponent as CreateFicha } from './ficha/create/create.component';
import { IndexComponent as IndexAprendiz } from './aprendiz/index/index.component';
import { CreateComponent as CreateAprendiz} from './aprendiz/create/create.component';
import { IndexComponent as IndexBono } from './bono/index/index.component';
import { CreateComponent as CreateBono } from './bono/create/create.component';
import { IndexComponent as IndexMaterial } from './material/index/index.component';
import { CreateComponent as CreateMaterial } from './material/create/create.component';
import { IndexComponent as IndexTip} from './tip/index/index.component';
import { CreateComponent as CreateTip } from './tip/create/create.component';
import { IndexComponent as IndexHistorialEntrega } from './historial/entrega/index/index.component';
import { IndexComponent as IndexHistorialBono } from './historial/bonos/index/index.component';



export const routes: Routes = [
    { path: '', redirectTo: 'inicio/body', pathMatch: 'full' },
    { path: 'inicio/body', component: BodyComponent },

    { path: 'ficha/index', component: IndexFicha},
    { path: 'ficha/create', component: CreateFicha},

    { path: 'aprendiz/index', component: IndexAprendiz},
    { path: 'aprendiz/create', component: CreateAprendiz},
    { path: 'aprendiz/edit/:id', component: CreateAprendiz },

    { path: 'bono/index', component: IndexBono},
    { path: 'bono/create', component: CreateBono},

    { path: 'material/index', component: IndexMaterial},
    { path: 'material/create', component: CreateMaterial},

    { path: 'tip/index', component: IndexTip},
    { path: 'tip/create', component: CreateTip},

    { path: 'historial/entrega/index', component: IndexHistorialEntrega},
    { path: 'historial/bonos/index', component: IndexHistorialBono},
   

];
